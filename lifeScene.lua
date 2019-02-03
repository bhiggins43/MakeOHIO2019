local composer = require( "composer" )
local lifeLogic = require( "lifeLogic" )
local colors = require( "colors" )
 
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
    tempMem:setFillColor(unpack(colors.green))

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
    lifeLogic.printState()
    -- destroyOldMembers()
    -- generateAliveMembers()
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
        coords = event.params.coordinates

        if (alive) then
            lifeLogic.generateInitialStateCustom(
                rows,
                cols,
                alive
            )
        else
            lifeLogic.generateInitialStateDefault(
                rows,
                cols,
                coords
            )
        end

        generateAliveMembers()
        lifeLogic.printState()
        intervalTimer = timer.performWithDelay( intervalDuration, timerListener, -1 )
 
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