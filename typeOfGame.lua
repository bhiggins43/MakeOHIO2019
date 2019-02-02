local composer = require( "composer" )
local widget = require( "widget" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local w = display.actualContentWidth
local h = display.actualContentHeight 
 
local function handleButtonEvent(event)
    if (event.phase == "ended") then
        if (event.target.id == "customButton") then
            print("Going to custom scene")
            composer.gotoScene("customScene")

        elseif (event.target.id == "defaultButton") then
            print("Going to default scene")
            composer.gotoScene("defaultScene")
        end
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        local numButtons = 2
        local buttonW = w * 0.8
        local buttonH = h / (numButtons + 1)

        local customButton = widget.newButton({
            id = "customButton",
            x = w / 2,
            y = h / (numButtons + 1) ,
            width = buttonW,
            height = buttonH,
            label = "CUSTOM",
            fontSize = h/20, 
            shape = "roundedRect",
            cornerRadius = (h/20) * 2 / 3,
            onEvent = handleButtonEvent,
            fillColor = { default ={ 0, 0, 0}, over = {1, 0, 0}},
            labelColor = { default = {1, 1, 1}, over = {1, 1, 1}}
        })

        local defaultButton = widget.newButton({
            id = "defaultButton",
            x = w / 2,
            y = customButton.y * 2,
            width = buttonW,
            height = buttonH,
            label = "DEFAULT",
            fontSize = h/20, 
            shape = "roundedRect",
            cornerRadius = (h/20) * 2 / 3,
            onEvent = handleButtonEvent,
            fillColor = { default ={ 1, 1, 1}, over = {1, 0, 0}},
            labelColor = { default = {0, 0, 0}, over = {0, 0, 0}}
        })

        sceneGroup:insert(customButton)
        sceneGroup:insert(defaultButton)

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
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene