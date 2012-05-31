-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5


-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- display a background image
	background = display.newImageRect( "images/img_bosques.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x, background.y = 0, 0	
	
	-- make a pig (off-screen), position it, and rotate slightly
	local mediumPig = display.newImageRect("images/cerdito_mediano_a.png", 230, 320)
	mediumPig:setReferencePoint(display.CenterReferencePoint)
	mediumPig.x, mediumPig.y = halfW -250, halfH + 150
	--pig.rotation = 0

	local littlePig = display.newImageRect("images/cerdito_pequenio_paja_a.png", 260, 320)
	littlePig:setReferencePoint(display.CenterReferencePoint)
	littlePig.x, littlePig.y = halfW , halfH + 150

	local bigPig = display.newImageRect("images/cerdito_grande_a.png", 250, 355)
	bigPig:setReferencePoint(display.CenterReferencePoint)
	bigPig.x, bigPig.y = halfW +250 , halfH + 130
----

----
	
	-- all display objects must be inserted into group
	group:insert(background)
	group:insert(littlePig)
	group:insert(mediumPig)
	group:insert(bigPig)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
-- Narrator voice starts
narrationSpeech = audio.loadSound("sounds/first_scene.mp3")

-- play the speech on any available channel, for at most 30 seconds, and invoke a callback when the audio finishes playing
narrationChannel = audio.play( narrationSpeech, { duration=30000, onComplete=NarrationFinished } )  


end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	package.loaded[physics] = nil
	physics = nil
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
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene