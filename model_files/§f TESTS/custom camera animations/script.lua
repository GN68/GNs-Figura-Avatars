pos = nil
_pos = nil
velocity = nil
distance_velocity = 0
distance_traveled = 0

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
end

function world_render(delta)
    distance_velocity = (velocity * vectors.of({1,0,1})).distanceTo(vectors.of({}))
    distance_traveled = distance_traveled + distance_velocity
    local localVel = {
        x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
        0,
        z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
    }
    camera.FIRST_PERSON.setPos({localVel.x,math.abs(math.sin(distance_traveled))*0.2 * math.min(distance_velocity,1),localVel.z})
end