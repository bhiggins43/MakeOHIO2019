local json = require("json")

local world = {}
local previousWorld = {}

local rows, cols, alive
local xShift = {-1, 0, 1, -1, 1, -1, 0, 1}
local yShift = {1, 1, 1, 0, 0, -1, -1, -1}

local function assignRandomAlive()
    math.randomseed( os.time() )
    local count = 0
    while count < alive do
        local rand1 = math.random(rows)
        local rand2 = math.random(cols)
        if world[rand1][rand2] == 0 then
            world[rand1][rand2] = 1
            count = count + 1
        end
    end
end

local function saveState()
    for i = 1, rows, 1 do
        for j = 1, cols, 1 do
            previousWorld[i][j] = world[i][j]
        end
    end
end

local function updateWorldCell(row, col, numAliveNeighbors)
    if world[row][col] == 1 then    -- Alive
        if numAliveNeighbors < 2 and numAliveNeighbors > 3 then
            world[row][col] = 0
        end
    else                            -- Dead
        if numAliveNeighbors == 3 then
            world[col][row] = 1
        end
    end
end

local v = {}

v.generateInitialStateCustom = function(numRows, numCols, numAlive)
    rows = numRows
    cols = numCols
    alive = numAlive
    for i = 1, numRows, 1 do
        world[i] = {}
        previousWorld[i] = {}
        for j = 1, numCols, 1 do
            world[i][j] = 0
        end
    end
    assignRandomAlive()
end

v.generateInitialStateDefault = function(numRows, numCols, coordinates)

end

v.generateNextState = function()
    saveState()

    for i = 1, rows, 1 do
        for j = 1, cols, 1 do
            local numAliveNeighbors = 0
            for n = 1, 8, 1 do

                local tempRow = i + xShift[n]
                if tempRow == rows + 1 then
                    tempRow = 1
                elseif tempRow == 0 then
                    tempRow = rows
                end

                local tempCol = j + yShift[n]
                if tempCol == cols + 1 then
                    tempCol = 1
                elseif tempCol == 0 then
                    tempCol = cols
                end

                numAliveNeighbors = numAliveNeighbors + previousWorld[tempRow][tempCol]
                print(numAliveNeighbors)

            end
            -- Update cell
            updateWorldCell(i, j, numAliveNeighbors)
        end
    end
end

v.printState = function()
    for k,v in pairs(world) do
        local s = ""
        for o,p in pairs(v) do
            s = s .. " "..p
        end
        print(s)
    end
    print("-------------------------------")
end

v.getCurrentState = function()
    return world
end

return v