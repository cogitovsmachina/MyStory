-- Project: Storyboard GoTo
--
-- Version: 1.2.1
--
-- Author: Johan Johansson @ Baboons.se
--
-- Support: www.baboons.se
--
-- Copyright (C) Baboons. All Rights Reserved.
--

local storyboard = require "storyboard"

-- Set helper
local function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- OnComplete Event
local function onComplete(view)
    local scene = view.scene
    local lastScene = view.lastScene
    local sceneName = storyboard.currentSceneName
    local loadedScenes = Set{unpack(storyboard.loadedSceneMods) }

    -- Exit current scene
    if lastScene then lastScene:exitScene() end

    -- Enter new scene
    scene:enterScene()

    -- Animate alpha if needed
    transition.to( view, { time=storyboard.effectTime,  alpha=1.0 } )

    -- Insert scene to loaded if needed
    if loadedScenes[sceneName] == nil then
        table.insert(storyboard.loadedSceneMods, sceneName)
    end

    -- Load done, remove layer
    view.layer:removeSelf()

end

-- Goto To Scene
local gotoScene = function ( sceneName, effect, effectTime)

    -- Get loaded Scenes
    local loadedScenes = Set{unpack(storyboard.loadedSceneMods)}

    -- Get The previous scene name
    local lastSceneName = storyboard.getPrevious()

    -- Get the previous scene
    local lastScene = storyboard.getScene( lastSceneName ) or nil

    -- Get or Load New Scene
    local scene = storyboard.getScene( sceneName ) or require( sceneName )

    -- Create Scene if not loaded
    if loadedScenes[sceneName] == nil then
        -- Create view group
       scene.view = display.newGroup()

       -- Save scene
       storyboard.scenes[sceneName] = scene

       -- Create scene
       scene:createScene()
    end

    -- Set current sceneName
    storyboard.currentSceneName = sceneName


    -- Set effect time
    storyboard.effectTime = effectTime

    -- Create View Group
    scene.view.scene = scene
    scene.view.lastScene = lastScene

    -- Set positions
    local newX = 0
    local newY = 0
    local curX = 0
    local curY = 0
    local alpha = 1.0
    local crossAlpha = 1.0

    if     effect == "fromRight" then
        newX =  display.contentWidth
    elseif effect == "fromLeft" then
        newX =  -display.contentWidth
    elseif effect == "fromTop" then
        newY =  -display.contentHeight
    elseif effect == "fromBottom" then
        newY =  display.contentHeight
    elseif effect == "toBottom" then
        curY = display.contentHeight
    elseif effect == "toTop" then
        curY = -display.contentHeight
    elseif effect == "slideLeft" then
        newX = display.contentWidth
        curX = -display.contentWidth
    elseif effect == "slideRight" then
        newX = -display.contentWidth
        curX = display.contentWidth
    elseif effect == "slideUp" then
        newY = display.contentHeight
        curY = -display.contentHeight
    elseif effect == "slideDown" then
        newY = -display.contentHeight
        curY = display.contentHeight
    elseif effect == "fade" then
        alpha = 0.0
        crossAlpha = 0.0
    elseif effect == "crossFade" then
        alpha = 0.0
        crossAlpha = 1.0
    end

    -- Move New Scene View out of screen
    scene.view.x = newX
    scene.view.y = newY

    -- Set new alpha
    scene.view.alpha = alpha

    -- Disable touch
    local layer = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    layer.alpha = 0.0
    layer.isHitTestable = true
    layer:addEventListener("touch", function() return true end)
    layer:addEventListener("tap", function() return true end)

    -- Add layer to view object
    scene.view.layer = layer

    -- Move New Scene
    transition.to( scene.view, { time=effectTime, alpha=crossAlpha, x=(0), y=(0), onComplete=onComplete } )

    -- Move Current Scene
    if lastScene then
        transition.to( lastScene.view, { time=effectTime, alpha=alpha, x=(curX), y=(curY) } )
    end


end

return gotoScene