-- scene3.lua
local storyboard = require("storyboard")
local movieclip = require("movieclip")
local scene = storyboard.newScene()


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = display.contentWidth*0.5, display.contentHeight*0.5
local mediumPig, littlePig, bigPig
local firstOption, secondOption
local myAnim

local function onNextButtonTouch(self,event)
	if (event.phase == "ended") then
		print("Next Button Pressed")
	end
	return true	
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene(event)
	local group = self.view

	-- Purging last Scene
	storyboard.purgeScene("scene2")

	-- display a background image
	background = display.newImageRect("images/background_botones.png", display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x, background.y = 0,0	
	-- Adding Navigation Button
	firstOption = display.newImageRect("images/boton_uno_pequeno.png",450,450)
	firstOption:setReferencePoint(display.CenterReferencePoint)
	firstOption.x, firstOption.y = halfW-250, halfH

	secondOption = display.newImageRect("images/boton_dos_pequeno.png",450,450)
	secondOption:setReferencePoint(display.CenterReferencePoint)
	secondOption.x, secondOption.y = halfW+250, halfH
	



		
	-- all display objects must be inserted into group
	group:insert(background)
	group:insert(firstOption)
	group:insert(secondOption)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	local group = self.view

-- Narrator voice starts
	narrationSpeech = audio.loadSound("sounds/third_scene.mp3")
-- play the speech on any available channel, for at most 30 seconds, and invoke a callback when the audio finishes playing
	narrationChannel = audio.play( narrationSpeech, { duration=30000, onComplete=NarrationFinished } )  -- play the speech on any available channel, for at most 30 seconds, and invoke a callback when the audio finishes playing
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
end


function NarrationFinished(event)
    print("Narration Finished on channel", event.channel)
    if event.completed then
        print("Narration completed playback naturally")
    else
        print("Narration was stopped before completion")
    end

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener("createScene",scene)

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener("enterScene",scene)

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener("exitScene",scene)

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener("destroyScene",scene)

-----------------------------------------------------------------------------------------

return scene