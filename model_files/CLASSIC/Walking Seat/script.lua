positionCurrent = nil
positionLast = nil
velocity = nil
velocityLast = nil

for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

function player_init()
    positionCurrent = player.getPos()
    positionLast = positionCurrent
    velocityLast = vectors.of({0})
    velocity = vectors.of({0})
end

function tick()
    positionLast = positionCurrent
    positionCurrent = player.getPos()
    velocityLast = velocity
    velocity = positionCurrent - positionLast
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(positionLast,positionCurrent,delta)*vectors.of({-16,-16,16}))
    if velocity.distanceTo(vectors.of({})) > 0.05 then
        model.NO_PARENT.setRot({0,180+math.deg(math.lerp(math.atan2(velocityLast.x,velocityLast.z),math.atan2(velocity.x,velocity.z),delta))})
        animation.get("walk").play()
    end
end