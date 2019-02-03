local roygbiv = {
    [1] = {1, 0 , 0},
    [2] = {1, 127/255, 0},
    [3] = {1,1,0},
    [4] = {0, 1, 0},
    [5] = {0, 0, 1},
    [6] = {75/255, 0, 130/255},
    [7] = {148/255, 0, 211/255}
}

local count = 1
local color = {
    r = roygbiv[1][1],
    g = roygbiv[1][2],
    b = roygbiv[1][3],
}--roygbiv[1]

local function transitionListener()
end

local function startColorTransition()
    count = count + 1
    -- print("count = "..count)
    local mod = (count % 7) + 1
    -- print("mod = "..mod)
    transition.to( color, {
        r = roygbiv[mod][1],
        g = roygbiv[mod][2],
        b = roygbiv[mod][3],
        a = 1,
        time = 2000,
        onComplete = startColorTransition
    })
    -- print("r, g, b = "..color.r..", "..color.g..", "..color.b)
end 

local v = {}

v.blue = {0,191/255,255/255}
v.lightblue = {0,165/255,255/255}

v.green = {50/255,205/255,50/255}
v.lightgreen = {40/255,225/255,40/255}

v.transitionColor = function( members )
    startColorTransition()
end

v.getCurrentColor = function()
    return color
end

return v
