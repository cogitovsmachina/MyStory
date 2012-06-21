-- scene1.lua

local storyboard = require("storyboard")
local movieclip = require("movieclip")
local scene = storyboard.newScene()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = display.contentWidth*0.5, display.contentHeight*0.5
local mediumPig, littlePig, bigPig
local nextButton
local myAnim, tree

local function onNextButtonTouch(self,event)
	if (event.phase == "ended") then
		storyboard.gotoScene( "scene2", "slideLeft", 350 )
		print("Next Button Pressed")
	end
	return true	
end

local function onMediumPigTouch(self,event)
	if (event.phase == "ended") then
		oink = audio.play(mid_oink)
		print("Medium says: Oink!")

		-- Start animations
		myAnim = movieclip.newAnim{ "images/scene1/cerdito_mediano_a.png", "images/scene1/cerdito_mediano_b.png" }
		myAnim.x, myAnim.y = halfW , halfH +150	
		myAnim:setSpeed(1)
		myAnim:play{startFrame=1, endFrame=2, loop=1, remove=true}
		return true	-- indicates successful touch
	end
end

local function onLittlePigTouch(self,event)
	if (event.phase == "ended") then
		littlePigOink = audio.play(little_oink)
		print("Little says: Oink!")
	end
	return true	
end

local function onBigPigTouch(self,event)
	if (event.phase == "ended") then
		littlePigOink = audio.play(big_oink)
		print("Big says: Oink!")
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
function scene:createScene( event )
	local group = self.view
  
local treeTransition = function( obj )
        print( "Tree has done transition" .. tostring( obj ) )
end


	-- display a background image
	background = display.newImageRect("images/scene1/img_bosques.png", display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x, background.y = 0,0	
	-- Adding Navigation Button
	nextButton = display.newImageRect("images/generic_scene/next_button_a.png",105,105)
	nextButton:setReferencePoint(display.CenterReferencePoint)
	nextButton.x, nextButton.y = screenW-75, screenH-150
	-- making some pigs!
	littlePig = display.newImageRect("images/scene1/cerdito_pequeno_a.png",330,325)
	littlePig:setReferencePoint(display.CenterReferencePoint)
	littlePig.x, littlePig.y = halfW -270, halfH +150 

	mediumPig = display.newImageRect("images/scene1/cerdito_mediano_a.png",230,320)
	mediumPig:setReferencePoint(display.CenterReferencePoint)
	mediumPig.x, mediumPig.y = halfW , halfH +150

	bigPig = display.newImageRect("images/scene1/cerdito_grande_a.png",250,355)
	bigPig:setReferencePoint(display.CenterReferencePoint)
	bigPig.x, bigPig.y = halfW +250 , halfH +130

	tree = display.newImageRect("images/scene1/tree.png",400,500)
	tree:setReferencePoint(display.BottomLeftReferencePoint)
	tree.x, tree.y = 0,650
	tree.alpha = 0

	transition.to( tree, { time=600, delay=4200, alpha=1.0, onComplete=treeTransition} ) 


	-- all display objects must be inserted into group
	group:insert(background)
	group:insert(littlePig)
	group:insert(mediumPig)
	group:insert(bigPig)
	group:insert(nextButton)
	group:insert(tree)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	local group = self.view
	storyboard.purgeScene("homescreen")

-- Narrator voice starts
	narrationSpeech = audio.loadSound("sounds/first_scene.mp3")
	mid_oink = audio.loadSound("sounds/mid_oink.mp3")
	little_oink = audio.loadSound("sounds/little_oink.mp3")
	big_oink = audio.loadSound("sounds/big_oink.mp3")

-- play the speech on any available channel, for at most 30 seconds, and invoke a callback when the audio finishes playing
	narrationChannel = audio.play( narrationSpeech, { duration=30000, onComplete=NarrationFinished } )  -- play the speech on any available channel, for at most 30 seconds, and invoke a callback when the audio finishes playing
	
	mediumPig.touch = onMediumPigTouch
	mediumPig:addEventListener("touch",mediumPig)

	littlePig.touch = onLittlePigTouch
	littlePig:addEventListener("touch",littlePig)

	bigPig.touch = onBigPigTouch
	bigPig:addEventListener("touch", bigPig)

	nextButton.touch = onNextButtonTouch
	nextButton:addEventListener("touch", nextButton)
end

-- Called when scene is about to move offscreen:
function scene:exitScene(event)
	local group = self.view
	-- remove unused elements
	audio.stop(narrationChannel)
	littlePig:removeEventListener("touch",littlePig)
	mediumPig:removeEventListener("touch",mediumPig)
	bigPig:removeEventListener("touch",bigPig)


end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene(event)
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