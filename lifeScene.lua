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
 
local w = display.actualContentWidth
local h = display.actualContentHeight
print("Width = "..w)
print("Height = "..h)

local function createMember(x, y, count, sceneGroup)
    local memWidth = w / cols
    local memHeight = h / rows
    local memX = (x - 1) * memWidth
    local memY = (y - 1) * memHeight

    members[count] = display.newRoundedRect( 
        sceneGroup, 
        memX, 
        memY, 
        memWidth, 
        memHeight, 
        10 
    )

    members[count].anchorX = 0
    members[count].anchorY = 0
    members[count]:setFillColor(unpack(colors.green))
end

local function generateAliveMembers( sceneGroup )
    members = {}
    local world = lifeLogic.getCurrentState()
    local count = 0
    for i = 1, rows, 1 do
        for j = 1, cols, 1 do
            if world[i][j] == 1 then
                print("("..i..", "..j..")")
                count = count + 1
                createMember(j, i, count, sceneGroup)
            end
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
            lifeLogic.generateInitialStateDefault(
                index
            )
        end

        generateAliveMembers( sceneGroup )

        -- local bob = display.newRoundedRect( 
        --     sceneGroup, 
        --     0, 
        --     0, 
        --     w, 
        --     h, 
        --     10 
        -- )
        -- bob.anchorX = 0
        -- bob.anchorY = 0
 
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