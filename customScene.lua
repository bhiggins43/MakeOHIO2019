local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local rowsTextField
local columnsTextField
local numAliveTextField
local startButton
 
local w = display.actualContentWidth
local h = display.actualContentHeight

local function inputIsFilled() 
    return rowsTextField.text ~= nil and rowsTextField.text ~= "" and
    columnsTextField.text ~= nil and columnsTextField.text ~= "" and
    numAliveTextField.text ~= nil and numAliveTextField.text ~= ""
end

local function inputIsValid()
    return numAliveTextField < (rowsTextField.text * columnsTextField.text) / 2 and
    rowsTextField.text < 200 and
    columnsTextField.text < 100
end

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        print(event.target.id .. " button pressed")
        if (inputIsFilled() and inputIsValid) then 
            
            composer.gotoScene("lifeScene", {params = {
                numRows = tonumber(rowsTextField.text),
                numCols = tonumber(columnsTextField.text),
                numAlive = tonumber(numAliveTextField.text),
                index = nil
            }})

        end
    end
end

local function inputListener( event )
    --infoClear()
    if ("rowsTextField" == event.target.id) then
        if ("submitted" == event.phase or "ended" == event.phase) then
            --infoUpdate("rowsTextField submitted")
            -- native.setKeyboardFocus( columnsTextField )
        end
    elseif ("columnsTextField" == event.target.id) then
        if ("submitted" == event.phase or "ended" == event.phase) then
            --infoUpdate("columnsTextField submitted")
            -- native.setKeyboardFocus( numAliveTextField )
        end
    elseif ("numAliveTextField" == event.target.id) then
        if ("submitted" == event.phase or "ended" == event.phase) then
            --infoUpdate( "numAliveTextField submitted" )
            -- native.setKeyboardFocus( nil )
            handleButtonEvent({phase="ended", target={id="startButton"}})
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
        local numOfItems = 4

        rowsTextField = native.newTextField(w/2, h/(numOfItems+1), w/1.4, h/20)
        rowsTextField.placeholder = "(# of rows)"
        rowsTextField.id = "rowsTextField"
        rowsTextField.inputType = "number"
        rowsTextField:addEventListener( "userInput", inputListener )

        columnsTextField = native.newTextField(w/2, 2 * rowsTextField.y, w/1.4, h/20)
        columnsTextField.placeholder = "(# of columns)"
        columnsTextField.id = "columnsTextField"
        columnsTextField.inputType = "number"
        columnsTextField:addEventListener( "userInput", inputListener )

        numAliveTextField = native.newTextField(w/2, 3 * rowsTextField.y, w/1.4, h/20)
        numAliveTextField.placeholder = "(# of alive)"
        numAliveTextField.id = "numAliveTextField"
        numAliveTextField.inputType = "number"
        numAliveTextField:addEventListener( "userInput", inputListener )

        local startButton = widget.newButton({
            id = "startButton",
            x = w / 2,
            y = 4 * rowsTextField.y,
            width = w/1.4,
            height = 2 * rowsTextField.height,
            label = "Start",
            fontSize = rowsTextField.height,
            shape = "roundedRect",
            cornerRadius = rowsTextField.height * 2 / 3,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( rowsTextField )
        sceneGroup:insert( columnsTextField )
        sceneGroup:insert( numAliveTextField )
        sceneGroup:insert( startButton )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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
        rowsTextField:removeSelf()
        columnsTextField:removeSelf()
        numAliveTextField:removeSelf()
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