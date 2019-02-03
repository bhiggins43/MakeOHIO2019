--File to create the scene for the default scene screen
local composer = require( "composer" )
local widget = require( "widget" )
local dis = require( "defaultInitialStates")
local colors = require( "colors" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
local w = display.actualContentWidth
local h = display.actualContentHeight
local defaultOptionTable
local previousSelectedIndex = -1
print(dis[1].name)

local function onRowRenderListener( event )
    local row = event.row
    local params = row.params
    if ( event.row.params ) then
        row.nameText = display.newText( params.name, 18, 0, native.systemFont, 18)
        row.nameText.anchorX = 0
        row.nameText.anchorY = 0.5
        row.nameText:setFillColor( 0 )
        row.nameText.y = row.height / 2
        row.nameText.x = 20
        row.isSelected = false -- not selected
        
        row.numberText = display.newText( params.number, 17, 0, native.systemFontBold, 18 )
        row.numberText.anchorX = 1
        row.numberText.anchorY = 0.5
        row.numberText:setFillColor( 0 )
        row.numberText.y = row.height / 2
        row.numberText.x = row.width - 20

        row:insert( row.nameText )
        row:insert( row.numberText )
    end
end

local function onRowTouchListener(event)
    if (event.phase == "release") then
        local row = event.row
        local params = row.params

        if (row.isSelected) then
            row.nameText:setFillColor(0)
            row.numberText:setFillColor(0)
            row.isSelected = false
        else
            row.nameText:setFillColor(1, 0, 0)
            row.numberText:setFillColor(1, 0, 0)
            row.isSelected = true
        end

        if ((previousSelectedIndex ~= row.index) and (previousSelectedIndex ~=-1)) then
            local previousRow = defaultOptionTable:getRowAtIndex(previousSelectedIndex)
            previousRow.nameText:setFillColor(0)
            previousRow.numberText:setFillColor(0)
            row.isSelected = false
        end
        previousSelectedIndex = row.index
    end
end

local function createDefaultOptionTableRows(  )
    for number, config in pairs(dis) do
        defaultOptionTable:insertRow{
            rowHeight = h / 17,
            rowColor = { default={ 0.8, 0.8, 0.8 }, over={ 0.7, 0.7, 0.9 } },
            lineColor = { 69/255, 137/255, 247/255 },
            params = {
               name = config.name,
               number = number
            }
         }
    end
end

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        print("First Condition")
        if (event.target.id == "continueButton") then
            print("Hit continue")
            print(previousSelectedIndex)
            local row = defaultOptionTable:getRowAtIndex(previousSelectedIndex)
            composer.gotoScene("lifeScene", {params = {
                numRows = nil
                numCols = nil
                numAlive = nil
                index = previousSelectedIndex
            }})
            
        end
    elseif (event.phase == "began") then
        --event.target:setFillColor(0,0,1)
        print("begin")
    end
end

local function inputListener( event )
    
   
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
        local tableHeight = display.actualContentHeight * 0.75

        local topRect = display.newRect(
            display.contentCenterX,
            display.topStatusBarContentHeight * 0.5,
            display.actualContentWidth,
            display.topStatusBarContentHeight
        )
        topRect:setFillColor(0.4)
        sceneGroup:insert(topRect)

        defaultOptionTable = widget.newTableView({
            x = display.contentCenterX,
            y = tableHeight * 0.5 + display.topStatusBarContentHeight,
            width = display.actualContentWidth,
            height = tableHeight,
            isBounceEnabled = true,
            onRowRender = onRowRenderListener,
            backgroundColor = {0.4},
            onRowTouch = onRowTouchListener,

            
        })
        local isCategory = false

        local tableBottom = defaultOptionTable.y + 0.5 * defaultOptionTable.height
        local buttonSpace = display.actualContentHeight - tableBottom

        local continueButton = widget.newButton({
            id = "continueButton",
            x = w / 2,
            y = tableBottom + buttonSpace / 4,
            width = w,
            height = h * 0.25,
            label = "Continue",
            fontSize = h/20,
            shape = "roundedRect", 
            cornerRadius = (h/20) * 2 / 3,
            fillColor = { default = colors.green, over = colors.lightgreen },
            labelColor = { default={ 0 }, over={ 0 } },
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( continueButton )
        sceneGroup:insert( defaultOptionTable )

        createDefaultOptionTableRows()
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