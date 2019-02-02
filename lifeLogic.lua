local world = {}

local v = {}

v.generateInitialStateCustom = function(numRows, numCols, numAlive)
    for i = 1, numRows, 1 do
        for j = 1, numCols, 1 do
            world[i][j] = 0
            print("0")
        end
    end
end

v.generateInitialStateDefault = function(numRows, numCols, coordinates)

end

return v