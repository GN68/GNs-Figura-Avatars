action_wheel.SLOT_1.setItem("minecraft:glass_pane")
action_wheel.SLOT_1.setTitle("placeMirror")

mirror_pos = vectors.of {}

action_wheel.SLOT_1.setFunction(function()
    ping.moveMirror(player.getTargetedBlockPos(false) + vectors.of {0, 1, 0})
end)

ping.moveMirror = function(pos)
    mirror_pos = pos
    model.NO_PARENT.setPos(mirror_pos * vectors.of {-16, -16, 16})
end

color = {}

function player_init()
    for y = 1, 10, 1 do
        for x = 1, 10, 1 do
            model.NO_PARENT["row" .. tostring(y)]["cube" ..
                tostring(x + (y - 1))].setColor({1, 0, 0})
        end
    end
end
