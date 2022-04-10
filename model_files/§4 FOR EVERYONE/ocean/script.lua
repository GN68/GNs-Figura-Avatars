scale = 10
change = 0
wasUp = false
up = keybind.newKey("up","I")
wasDown = false
down = keybind.newKey("down","K")

ping.offset = function (val)
    change = val
end

function tick()
    scale = scale + change*0.1
    if up.isPressed() ~= wasUp then
        if up.isPressed() then
            ping.offset(1)
        else
            ping.offset(0)
        end
    end
    wasUp=up.isPressed()
    if down.isPressed() ~= wasDown then
        if down.isPressed() then
            ping.offset(-1)
        else
            ping.offset(0)
        end
        
    end
    wasDown =  down.isPressed()
end

function world_render(delta)
    model.NO_PARENT.setScale{scale,scale,scale}
    model.NO_PARENT.setPos(renderer.getCameraPos()*vectors.of{-16,-16,16})
    model.NO_PARENT.setRot(renderer.getCameraRot())
end