local composer = require( "composer" )
local lifeLogic = require( "lifeLogic" )
local colors = require( "colors" )
local json = require("json")
local widget = require( "widget" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local rows, cols, alive, coords
local members = {}
local intervalDuration = 500
local intervalTimer
 
local w = display.actualContentWidth
local h = display.actualContentHeight

local function createMember(x, y)
    local memWidth = w / cols
    local memHeight = h / rows
    local memX = (x - 1) * memWidth + 0.5 * memWidth
    local memY = (y - 1) * memHeight + 0.5 * memHeight

    local tempMem = display.newRoundedRect( 
        memX, 
        memY, 
        memWidth - 2, 
        memHeight - 2, 
        10 
    )
    -- local c1 = math.random( 0, 255 ) / 255
    -- local c2 = math.random( 0, 255 ) / 255
    -- local c3 = math.random( 0, 255 ) / 255
    local r = colors.getCurrentColor().r
    local g = colors.getCurrentColor().g
    local b = colors.getCurrentColor().b
    tempMem:setFillColor(r, g, b)
    -- tempMem:setFillColor(c1, c2, c3)

    table.insert(members, tempMem)
end

local function generateAliveMembers()
    local world = lifeLogic.getCurrentState()
    local count = 0
    for i = 1, rows, 1 do
        for j = 1, cols, 1 do
            if world[i][j] == 1 then
                createMember(j, i, sceneGroup)
            end
        end
    end
    -- colors.transitionColor()
end

local function destroyOldMembers()
    for k,v in pairs(members) do
        v:removeSelf()
        v = nil
    end
    members = {}
end

local function timerListener( event )
    lifeLogic.generateNextState()
    destroyOldMembers()
    generateAliveMembers()
end
 
local function updateColor( event )
    for k,v in pairs(members) do
        local r = colors.getCurrentColor().r
        local g = colors.getCurrentColor().g
        local b = colors.getCurrentColor().b
        v:setFillColor(r, g, b)
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
        rows = event.params.numRows
        cols = event.params.numCols
        alive = event.params.numAlive
        index = event.params.index

        if (not index) then
            lifeLogic.generateInitialStateCustom(
                rows,
                cols,
                alive
            )
        else
            print("Default Scene")
            lifeLogic.generateInitialStateDefault(
                index
            )
        end

        generateAliveMembers()
        intervalTimer = timer.performWithDelay( intervalDuration, timerListener, -1 )
        colors.transitionColor()
        Runtime:addEventListener( "enterFrame", updateColor )
 
        local quitButton = widget.newButton({
            id = "quitButton",
            x = w * 0.05,
            y = h * 0.95,
            radius = w/14,
            fontSize = 45,
            label = "X",
            shape = "circle",
            fillColor = { default = colors.green, over = colors.lightgreen },
            labelColor = { default={ 0 }, over={ 0 } },
            onEvent = handleButtonEvent,
        })

        quitButton.anchorX = 0
        quitButton.anchorY = 1

        sceneGroup:insert( quitButton )

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
        destroyOldMembers()
        Runtime:removeEventListener( "enterFrame", updateColor )
        timer.cancel(intervalTimer)

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