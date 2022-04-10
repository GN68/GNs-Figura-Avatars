
data = {}
locked = {}
tetromino = {
    I={
        origin={x=2,y=2,even=true},
        tiles = {{x=0,y=1},{x=1,y=1},{x=2,y=1},{x=3,y=1}},
        dimensions={x=4,y=4}
    },
    J={
        origin={x=1,y=1,even=false},
        tiles = {{x=0,y=0},{x=0,y=1},{x=1,y=1},{x=2,y=1}},
        dimensions={x=3,y=3}
    },
    L={
        origin={x=1,y=1,even=false},
        tiles = {{x=2,y=0},{x=0,y=1},{x=1,y=1},{x=2,y=1}},
        dimensions={x=3,y=3}
    },
    O={
        origin={x=1,y=1,even=true},
        tiles = {{x=1,y=0},{x=1,y=1},{x=0,y=1},{x=0,y=1},},
        dimensions={x=2,y=2}
    },
    S={
        origin={x=1,y=1,even=false},
        tiles = {{x=1,y=0},{x=2,y=0},{x=1,y=1},{x=2,y=1},},
        dimensions={x=3,y=3}
    },
    T={
        origin={x=1,y=1,even=false},
        tiles = {{x=1,y=0},{x=2,y=0},{x=1,y=1},{x=2,y=1},},
        dimensions={x=3,y=3}
    },
    Z={
        origin={x=1,y=1,even=false},
        tiles = {{x=1,y=0},{x=0,y=0},{x=1,y=1},{x=0,y=1},},
        dimensions={x=3,y=3}
    },
}
--==========================--
function getTileData(x,y)
    return data[toIndex(x,y)]
end

function getTileLock(x,y)
    return locked[toIndex(x,y)]
end

function toIndex(x,y)
    return ((y)*10)+(x)
end

function setTileData(x,y,id)
    local index = toIndex(x,y)
    data[index] = id
    if id == 0 then
        locked[index] = 0
    end
end

function setTileLock(x,y,id)
    locked[toIndex(x,y)] = id
end

function ofst(x,y)
    return {x=clamp(x,1,10),y=clamp(y,1,24)}
end

function ofstX(x)
    return clamp(x,1,10)
end

function ofstY(y)
    return clamp(y,0,24)
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

function clrGrid()
    timer = 0
    local index = 0
    data = {}
    locked = {}
    for _ = 0, 24, 1 do
        for _ = 1, 10, 1 do
            index = index + 1
            if math.floor(math.random()*10) == 1 then
                data[index] = 1
            else
                data[index] = 0
            end
            locked[index] = 1
        end
    end
end

function lockAll()
    local index = 0
    locked = {}
    for _ = 0, 24, 1 do
        for _ = 1, 10, 1 do
            index = index + 1
            locked[index] = 1
        end
    end
end

function dispUpdt()
    local index = 0
    for Y = 24, 1, -1 do
        for X = 1, 10, 1 do
            index = index + 1
            model.NO_PARENT.grid["row"..Y][X].setEnabled(data[index] == 1)
        end
    end
end

function spawnTetromino(type)
    local tetro = tetromino[type]
    local offset = {x=math.ceil(tetro.dimensions.x*0.5),y=tetro.dimensions.y}
    for key, tile in pairs(tetro.tiles) do
        setTileData(5-offset.x+tile.x,tile.y-offset.y+24,1)
        setTileLock(5-offset.x+tile.x,tile.y-offset.y+24,0)
    end
    currentTetromino = type
    timer = 0
end
--============================--
timer = 0
simulationDelay = 10
currentTetromino = ""

reset = keybind.newKey("Reset","R")
spawnTile = keybind.newKey("Spawn Tile","F")

function player_init()
   clrGrid() 
end

function tick()
    timer = timer - 1
    if timer < 0 then
        simulate()
        timer = simulationDelay
    end
    if reset.wasPressed() then
        clrGrid()
    end
    if spawnTile.wasPressed() then
        spawnTetromino("L")
    end
end

function simulate()
    local canMove = true
    for Y = 1, 24, 1 do
        for X = 1, 10, 1 do
            if getTileLock(X,Y) == 0 then
                if getTileData(X,Y) ~= 0 then
                    if getTileData(X,ofstY(Y-1)) ~= 0 then
                        canMove = false
                    end
                end
            end
        end
    end
    for Y = 1, 24, 1 do
        for X = 1, 10, 1 do
            if canMove then
                if getTileLock(X,Y) == 0 then
                    if getTileData(X,Y) ~= 0 then
                        if getTileData(X,ofstY(Y-1)) == 0 then
                            setTileData(X,ofstY(Y-1),1)
                            setTileLock(X,ofstY(Y-1),0)
                            setTileData(X,Y,0)
                        else
                            lockAll()
                        end
                    end
                end
            end
        end
    end
    dispUpdt()
end
