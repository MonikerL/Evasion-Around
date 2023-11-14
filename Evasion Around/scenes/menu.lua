local composer = require( "composer" )
local scene = composer.newScene()

local W, H = display.contentWidth, display.contentHeight
math.randomseed( os.time( ) )
local font = native.newFont("fonts/glacial-indifference/GlacialIndifference-Regular")
composer.removeScene("scenes.game")

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        local data = loadData("bestScore.json")
        best_score = data["value"]
        display.setDefault( "background", 0.19 )
      elseif ( phase == "did" ) then

            local play_group = display.newGroup()
            sceneGroup:insert(play_group)

            local play_static = display.newImageRect(play_group, "img/play_button_static.jpg", W / 2, W / 2)
            play_static.x = W / 2
            play_static.y = H / 2

            local play_dynamic = display.newImageRect(play_group, "img/play_button_dynamic.png", W / 2, W / 2)
            play_dynamic.x = W / 2
            play_dynamic.y = H / 2
            play_dynamic.fill.effect = "generator.sunbeams"
            play_dynamic.fill.effect.posX = 0.5
            play_dynamic.fill.effect.posY = 0.5
            play_dynamic.fill.effect.aspectRatio = ( play_dynamic.width / play_dynamic.height )
            play_dynamic.fill.effect.seed = 0

            transition.to( play_dynamic, {time = 1000, rotation = 360, iterations = -1} )

            function play_group:touch(event)
                if event.phase == "began" then
                    composer.gotoScene("scenes.game")
                end
                return true
            end
            play_group:addEventListener("touch", play_group)

            local text1_content = [[
                1. Keep your finger on the screen
                to rotate counterclockwise.

                2. Don't touch the screen to
                rotate clockwise.
            ]]
            local text1 = display.newText(sceneGroup, text1_content, 0, 0, font, 60)
            text1.x = W / 2 - text1.width / 4 + text1.width / 8
            text1.y = (H / 2 - play_dynamic.height / 2 + text1.height / 2) / 2

            local death_icon = display.newImageRect( sceneGroup, "img/circle_death.png", W / 8, W / 8 )
            death_icon.x = death_icon.width
            death_icon.y = H - play_dynamic.height / 2 + death_icon.height / 2
            local death_text = display.newText(sceneGroup, "      takes one life out of three.", death_icon.x, death_icon.y, font, 60)
            death_text.x = W / 2

            local plus_icon = display.newImageRect( sceneGroup, "img/circle_plus.png", W / 8, W / 8 )
            plus_icon.x = plus_icon.width
            plus_icon.y = death_icon.y - plus_icon.height
            local plus_text = display.newText(sceneGroup, "      increases the size of circles.", plus_icon.x, plus_icon.y, font, 60)
            plus_text.x = W / 2

            local minus_icon = display.newImageRect( sceneGroup, "img/circle_minus.png", W / 8, W / 8 )
            minus_icon.x = minus_icon.width
            minus_icon.y = plus_icon.y - plus_icon.height
            local minus_text = display.newText(sceneGroup, "      reduces the size of circles.", minus_icon.x, minus_icon.y, font, 60)
            minus_text.x = W / 2

            local coin_icon = display.newImageRect( sceneGroup, "img/coin_icon.png", W / 8, W / 8 )
            coin_icon.x = coin_icon.width
            coin_icon.y = minus_icon.y - coin_icon.height
            local icon_text = display.newText(sceneGroup, "      gives you +10 coins.", coin_icon.x, coin_icon.y, font, 60)
            icon_text.x = W / 2
            
            local best_score_group = display.newGroup()
            sceneGroup:insert(best_score_group)

            local upperText = display.newText(best_score_group, "BEST SCORE", 0, 0, font, 50)
            local lowerText = display.newText(best_score_group, best_score, 0, upperText.height, font, 50)

            best_score_group.x = W / 2
            best_score_group.y = display.safeScreenOriginY + best_score_group.height / 2
      end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
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