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
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

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
	background = display.newImageRect( "img_bosques.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0	
	
	-- make a pig (off-screen), position it, and rotate slightly
	local pig1 = display.newImageRect("cerdito_mediano_a.png", 230, 320)
	pig1:setReferencePoint(display.CenterLeftReferencePoint)
	pig1.x, pig1.y = 160, -100
	--pig.rotation = 0

	local pig2 = display.newImageRect("cerdito_pequenio_paja_a.png", 260, 320)
	pig2:setReferencePoint(display.CenterRightReferencePoint)
	pig2.x, pig2.y = 460, -100

	local pig3 = display.newImageRect("cerdito_pequenio.png", 330, 325)
	pig3:setReferencePoint(display.CenterRightReferencePoint)
	pig3.x, pig3.y = 460, -100
	
	-- add physics to the pig
	physics.addBody( pig1, { density=1.0, friction=0.3, bounce=0.3 } )
	physics.addBody( pig2, { density=1.0, friction=0.3, bounce=0.3 } )
	physics.addBody( pig3, { density=1.0, friction=0.3, bounce=0.3 } )

	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( grass)
	group:insert( pig1 )
	group:insert(pig2)
	group:insert(pig3)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	package.loaded[physics] = nil
	physics = nil
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