local composer = require( "composer" )
local scene = composer.newScene()
local W, H = display.contentWidth, display.contentHeight
local player_rad = W / 14
local dist = W / 2
local border_size = player_rad / 8
local rotation_speed = 5.4
local obstacles_interval = 600
local obstacle_rad = W / 16
local obstacle_speed = 2500
local obstacle_speed_delta = 10
local coefficient = 1.31
local max_number = 3
local current_number = 0
local lifes = 3
score = 0
data = loadData("bestScore.json")
bestScore = data["value"]

local plus_paint = {
    type = "image",
    filename = "img/circle_plus.png"
}
local minus_paint = {
    type = "image",
    filename = "img/circle_minus.png"
}
local death_paint = {
    type = "image",
    filename = "img/circle_death.png"
}
local coin_paint = {
    type = "image",
    filename = "img/coin_icon.png"
}

local font = native.newFont("fonts/glacial-indifference/GlacialIndifference-Regular")

composer.removeScene("scenes.menu")

math.randomseed( os.time( ) )

coin_sound = audio.loadSound( "sounds/pickupCoin.wav" )
hurt_sound = audio.loadSound( "sounds/hitHurt.wav" )
power_up_sound = audio.loadSound( "sounds/powerUp.wav" )

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        display.setDefault( "background", 0.1 )
      elseif ( phase == "did" ) then

            local central_group = display.newGroup()
            sceneGroup:insert(central_group)

            local central_circle = display.newCircle(central_group, 0, 0, W / 4)
            central_circle:setFillColor(0.81)
            
            local sub_central_circle = display.newCircle(central_group, 0, 0, W / 4 - border_size)
            sub_central_circle:setFillColor(0.1)

            central_group.anchorChildren = true
            central_group.anchorX = 0.5
            central_group.anchorY = 0.5

            local player_group = display.newGroup()
            sceneGroup:insert(player_group)

            local player = display.newCircle(player_group, 0, 0, player_rad)
            player:setFillColor(0.81)
            player.fill.effect = "generator.sunbeams"
            player.fill.effect.posX = 0.5
            player.fill.effect.posY = 0.5
            player.fill.effect.aspectRatio = ( player.width / player.height )
            player.fill.effect.seed = 0

            local circle = display.newCircle(player_group, player.x + dist, player.y, player_rad)
            circle:setFillColor(0.5, 1, 0.5)
            circle.isVisible = false

            player_group.anchorChildren = true
            player_group.anchorX = 0.5
            player_group.anchorY = 0.5
            player_group.x = W / 2
            player_group.y = H - dist - player_rad
            
            central_group.x = W / 2
            central_group.y = player_group.y

            local touch_zone = display.newRect(sceneGroup, W / 2, H / 2, W * 3, H * 3)
            touch_zone.alpha = 0.01
            
            local hold = false

            function touch_zone:touch(event)
                if event.phase == "began" and hold == false then
                    hold = true
                elseif event.phase == "ended" and hold == true then
                    hold = false
                end
                return true
            end
            touch_zone:addEventListener("touch", touch_zone)

            local obstacles_group = display.newGroup()
            sceneGroup:insert(obstacles_group)

            local score_text = display.newText(sceneGroup, score, 0, 0, font, 100)
            score_text.x = W / 2
            score_text.y = display.actualContentHeight - score_text.height / 2
            score_text:setFillColor(0.81)

            local function removeLastObstacle()
                obstacles_group[1]:removeSelf()
                obstacles_group[1] = nil
                score = score + 1
                if score > bestScore then
                    bestScore = score
                    data["value"] = bestScore
                end
                score_text.text = score
                score_text.x = W / 2
                obstacle_speed = math.max(obstacle_speed - obstacle_speed_delta, 1000)
            end

            local function generateObstacles()
                local obstacle = display.newCircle(obstacles_group, math.random(obstacle_rad, W - obstacle_rad), display.safeScreenOriginY + obstacle_rad, obstacle_rad)
                local rand_kind = math.random(1, 18)
                if rand_kind <= 10 then
                    obstacle:setFillColor(0.19)
                    obstacle.fill = death_paint
                    obstacle.kind = "death"
                else
                    if rand_kind == 11 or rand_kind == 12 then
                        obstacle.fill = minus_paint
                        obstacle.kind = "minus"
                    elseif rand_kind == 13 or rand_kind == 14 then
                        obstacle.fill = plus_paint
                        obstacle.kind = "plus"
                    elseif rand_kind == 15 or rand_kind == 16 then
                        obstacle.fill.effect = "generator.sunbeams"
                        obstacle.fill.effect.posX = 0.5
                        obstacle.fill.effect.posY = 0.5
                        obstacle.fill.effect.aspectRatio = ( obstacle.width / obstacle.height )
                        obstacle.fill.effect.seed = 0
                        obstacle.kind = "life"
                    elseif rand_kind == 17 or rand_kind == 18 then
                        obstacle.fill = coin_paint
                        obstacle.kind = "coin"

                    end
                end
                transition.to(obstacle, {time = obstacle_speed, y = H + obstacle.height / 2, onComplete = removeLastObstacle})
            end

            generateObstacles()
            local obstacles_timer = timer.performWithDelay(obstacles_interval, generateObstacles, -1)

            local lifes_group = display.newGroup()
            sceneGroup:insert(lifes_group)

            local central_life = display.newCircle(lifes_group, 0, 0, obstacle_rad / 1.618)
            central_life.fill.effect = "generator.sunbeams"
            central_life.fill.effect.posX = 0.5
            central_life.fill.effect.posY = 0.5
            central_life.fill.effect.aspectRatio = ( central_life.width / central_life.height )
            central_life.fill.effect.seed = 0
            local left_life = display.newCircle(lifes_group, -obstacle_rad * 1.618, 0, obstacle_rad / 1.618)
            left_life.fill.effect = "generator.sunbeams"
            left_life.fill.effect.posX = 0.5
            left_life.fill.effect.posY = 0.5
            left_life.fill.effect.aspectRatio = ( left_life.width / left_life.height )
            left_life.fill.effect.seed = 0
            local right_life = display.newCircle(lifes_group, obstacle_rad * 1.618, 0, obstacle_rad / 1.618)
            right_life.fill.effect = "generator.sunbeams"
            right_life.fill.effect.posX = 0.5
            right_life.fill.effect.posY = 0.5
            right_life.fill.effect.aspectRatio = ( right_life.width / right_life.height )
            right_life.fill.effect.seed = 0

            lifes_group.x = W / 2
            lifes_group.y = player_group.y

            local collision_state_array = {}
            
            local function gameLoop()
                if hold == true then
                    player_group.rotation = (player_group.rotation - rotation_speed) % 360
                else
                    player_group.rotation = (player_group.rotation + rotation_speed) % 360
                end

                local player_x = player_group.x - (dist / 2) * math.cos(math.rad(player_group.rotation))
                local player_y = player_group.y - (dist / 2) * math.sin(math.rad(player_group.rotation))
                
                local collision_state = false
                local index = 1

                for i = 1, obstacles_group.numChildren do
                    if math.sqrt(math.pow(player_x - obstacles_group[i].x, 2) + math.pow(player_y - obstacles_group[i].y, 2)) < player.width / 2 + obstacle_rad then
                        collision_state = true
                        index = i
                        break
                    end
                end

                table.insert(collision_state_array, collision_state)
                if #collision_state_array > 2 then
                    table.remove(collision_state_array, 1)
                end
                if collision_state_array[1] == false and collision_state_array[2] == true then --collision entry
                    if obstacles_group[index].kind == "death" and obstacles_group[index].isVisible == true  then
                        lifes = lifes - 1
                        local red_splash = display.newRect(sceneGroup, W / 2, H / 2, display.actualContentWidth * 10, display.actualContentHeight * 10)
                        red_splash:setFillColor(0.31, 0.19, 0.19)
                        local function removeRedSplash()
                            red_splash:removeSelf()
                            red_splash = nil
                        end
                        transition.to(red_splash, {time = 400, alpha = 0, onComplete = removeRedSplash})
                        audio.play(hurt_sound)
                        if lifes == 2 then
                            right_life.isVisible = false
                        elseif lifes == 1 then
                            central_life.isVisible = false
                        elseif lifes == 0 then
                            transition.cancelAll()
                            timer.cancelAll()
                            Runtime:removeEventListener("enterFrame", gameLoop)
                            composer.gotoScene("scenes.menu")
                        end
                    elseif obstacles_group[index].kind == "plus" and current_number < max_number and obstacles_group[index].isVisible == true  then
                        obstacle_rad = obstacle_rad * coefficient
                        current_number = current_number + 1
                    elseif obstacles_group[index].kind == "minus" and current_number > 0 and obstacles_group[index].isVisible == true  then
                        obstacle_rad = obstacle_rad / coefficient
                        current_number = current_number - 1
                    elseif obstacles_group[index].kind == "life" and lifes < 3 and obstacles_group[index].isVisible == true  then
                        if lifes == 1 then
                            central_life.isVisible = true
                        elseif lifes == 2 then
                            right_life.isVisible = true
                        end
                        lifes = lifes + 1
                        local green_splash = display.newRect(sceneGroup, W / 2, H / 2, display.actualContentWidth * 10, display.actualContentHeight * 10)
                        green_splash:setFillColor(0.19, 0.31, 0.19)
                        local function removeGreenSplash()
                            green_splash:removeSelf()
                            green_splash = nil
                        end
                        transition.to(green_splash, {time = 400, alpha = 0, onComplete = removeGreenSplash})
                        audio.play(power_up_sound)
                    elseif obstacles_group[index].kind == "coin" and obstacles_group[index].isVisible == true then
                        score = score + 10
                        if score > bestScore then
                            bestScore = score
                            data["value"] = bestScore
                        end
                        score_text.text = score
                        score_text.x = W / 2
                        score_text.y = display.actualContentHeight - score_text.height / 2
                        audio.play(coin_sound)
                    end
                    obstacles_group[index].isVisible = false
                end
            end
            Runtime:addEventListener("enterFrame", gameLoop)
            score_text:toFront()
      end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        saveData(data, "bestScore.json")
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
-- -----------------------------------------------------------------------------------
 
return scene