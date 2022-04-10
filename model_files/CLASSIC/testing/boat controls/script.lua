currentYaw = nil
lastYaw = nil
currentRotVel = 0
lastRotVel = 0

function player_init()
    currentYaw = player.getBodyYaw()
    lastYaw = currentYaw
end

function tick()
    lastYaw = currentYaw
    currentYaw = player.getBodyYaw()
    lastRotVel = currentRotVel
    currentRotVel = (lastYaw-currentYaw)
end

function world_render(delta)
    model.HUD.Rotation.setPos({lerp(lastRotVel,currentRotVel,delta)})
end

function lerp(a, b, x)
    return a + (b - a) * x
end
