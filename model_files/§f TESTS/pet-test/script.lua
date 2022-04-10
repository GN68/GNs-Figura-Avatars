
-- the lower the value the more worn down the shake will be
-- value higher than 1 will cause it to get stronger

position = {0,0,0}
velocity = {0,0,0}

pos = {0,0,0}

keybindReset = keybind.newKey("reset","R")

function player_init()
    playerPos2model = {player.getPos().x*-16,player.getPos().y*-16,player.getPos().z*16}
    position = playerPos2model
end

function tick()
    
    playerPos2model = {player.getPos().x*-16,player.getPos().y*-16,player.getPos().z*16}
    
    if not string.find(world.getBlockState(position).name,"air") then
        position[2] = position[2] - (velocity[2]-0.001)
        lastInBlock = true
        
        if lastInBlock then
            velocity[2] = 0
            if not string.find(world.getBlockState(position).name,"air") then
                position[2] = position[2] + 1
            end
        end
    else
        velocity[2] = velocity[2] - 0.05
        lastInBlock = false
    end
    
    if keybindReset.isPressed() then
        position = {player.getPos().x,player.getPos().y+10,player.getPos().z}
        --position = {1,9,-12}
        velocity = {0,0,0}
    end
    position[2] = position[2]+velocity[2]
    position[1] = position[1]+ velocity[1]
    position[3] = position[3]+ velocity[3]
    velocity[1] = velocity[1] *0.9
    velocity[3] = velocity[3] *0.9
    if math.abs(tableDistance(position,{model.NO_PARENT.getPos().x/-16,model.NO_PARENT.getPos().y/-16,model.NO_PARENT.getPos().z/16})) > 0.1 then
        local stiffness = 0.4
        pos[1] = lerp(model.NO_PARENT.getPos().x,position[1]*-16,stiffness)
        pos[2] = lerp(model.NO_PARENT.getPos().y,position[2]*-16,stiffness)
        pos[3] = lerp(model.NO_PARENT.getPos().z,position[3]*16,stiffness)
    end

    if math.abs(tableDistance(position,{player.getPos().x,player.getPos().y,player.getPos().z})) > 10 then
        local movement = {0,0}
        movement = normalize((player.getPos().x-position[1]),(player.getPos().z-position[3]))
        velocity[1] = movement[1]*0.2
        velocity[3] = movement[2]*0.2
    end
    model.NO_PARENT.setPos(pos)
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function dotp(value)
    return value/math.abs(value)
end

function tableDistance(from,to)
    local final = 0.0
    for I , spherez_doggoes in pairs(from) do
        final = final + math.pow(from[I]-to[I],2)
    end
    return math.sqrt(final)
end


function tableDistanceCenter(from)
    local final = 0.0
    for I , my_humor_on_washing_machines in pairs(from) do
        final = final + math.pow(from[I],2)
    end
    return math.sqrt(final)
end

function tableNormalize(table)
    return table / tableDistanceCenter(table)
end

function normalize(x,y)
    local a = x / tableDistanceCenter({x,y})
    local b = y / tableDistanceCenter({x,y})
    return {a,b}
end