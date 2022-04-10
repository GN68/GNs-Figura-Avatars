
action_wheel.SLOT_1.setTexture("Custom")
action_wheel.SLOT_1.setUV({0,0},{128,32},{128,32})
action_wheel.SLOT_1.setTitle("GN's Redstone Utility Avatar v0.1")
action_wheel.SLOT_1.setFunction(function ()
    local chosenPitch = math.floor(math.lerp(-4,4,math.random())+0.5)
    sound.playSound("minecraft:block.note_block.guitar",player.getPos(),{1,2^(chosenPitch/12)})
end)

blockIndex = {
    "yellow_stained_glass",--input
    "red_stained_glass",--wires
    "lime_stained_glass",--output
}

workspace = model.NO_PARENT_WORKSPACE
world = {}
action = false


config = {
    debug = {
        logUpdates = true
    },
}

vectors.worldspace = vectors.of{-16,-16,16}

action_wheel.SLOT_2.setItem("redstone")
action_wheel.SLOT_2.setFunction(function ()
    local source = player.getTargetedBlockPos(false)
    if source then
        --world = {}
        action = true
        setBlock(source,1)
    end
end)

function setBlock(pos,val)
    if world[pos[1]] then
        if world[pos[1]][pos[2]] then
            world[pos[1]][pos[2]][pos[3]] = val
            setDebugBlock(pos,blockIndex[val])
            if config.debug.logUpdates then
                log([=[[WRLD] Blck Plcd ]=]..tostring(pos[1]).." "..tostring(pos[2]).." "..tostring(pos[3]))
            end
        else world[pos[1]][pos[2]] = {} setBlock(pos,val) end
    else world[pos[1]] = {} setBlock(pos,val) end
end

function getBlock(pos,val)
    if world[pos[1]] then
        if world[pos[1]][pos[2]] then
            if world[pos[1]][pos[2]][pos[3]] then
                return world[pos[1]][pos[2]][pos[3]]
            else return nil end
        else return nil end
    else return nil end
end

function setDebugBlock(pos,block)
    local posName = "x"..tostring(pos[1]).."y"..tostring(pos[2]).."z"..tostring(pos[3])
    if workspace.getRenderTask(posName) then
        if block == nil then
            workspace.removeRenderTask(posName)
        else
            workspace.getRenderTask(posName).setBlock(block)
        end
    else
        workspace.addRenderTask("BLOCK",posName,block,false,(pos+vectors.of{1.0005,-0.0005,1.0005})*vectors.worldspace,{},{1.001,1.001,1.001})
    end
end

function flood_fill()
    for Z, value in pairs(world) do
        for Y, value in pairs(world[Z]) do
            for X, value in pairs(world[Z][Y]) do
                local current = vectors.of{X,Y,Z}
                
            end
        end
    end
end