native.setProperty("androidSystemUiVisibility", "immersiveSticky")

local composer = require("composer")
local fo = require("file_operations")

local bestScore = {
      value = 0
}     

--os.remove( system.pathForFile( "bestScore.json", system.DocumentsDirectory ) )

if not doesFileExist("bestScore.json", system.DocumentsDirectory) then
      saveData(bestScore, "bestScore.json")
      print("file saved")
end

composer.gotoScene( "scenes.menu" )