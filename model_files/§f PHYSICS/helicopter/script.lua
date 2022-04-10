position = vectors.of{0,11,0}
lastPosition = position

rotation = vectors.of{}
lastRotation = rotation

linearVelocity = vectors.of{0,0,0}
angularVelocity = vectors.of{}

action_wheel.SLOT_1.setFunction(function ()
    linearVelocity = player.getLookDir()*0.5
    position = player.getPos() + vectors.of{0,player.getEyeHeight()}
end)


gravity = 0.025

friction = 0.8

margin = 0.01


function tick()
    lastPosition = position
    lastRotation = rotation

    linearVelocity = linearVelocity - vectors.of{0,gravity,0}

    linearVelocity = linearVelocity * 0.95

    local ray = renderer.raycastBlocks(position, position+vectors.of{linearVelocity.x,0,0}, "COLLIDER", "NONE")
    if ray then
        position = vectors.of{
            ray.pos.x - dotp(linearVelocity.x)*margin,
            position.y+linearVelocity.y,
            position.z+linearVelocity.z
        }
        linearVelocity = (linearVelocity * vectors.of{0,friction,friction})
    else
        position = position + (linearVelocity * vectors.of{1,0,0})
    end

    ray = renderer.raycastBlocks(position, position+vectors.of{0,linearVelocity.y,0}, "COLLIDER", "NONE")
    if ray then
        position = vectors.of{
            position.x+linearVelocity.x,
            ray.pos.y - dotp(linearVelocity.y)*margin,
            position.z+linearVelocity.z
        }
        linearVelocity = (linearVelocity * vectors.of{friction,0,friction})
    else
        position = position + (linearVelocity * vectors.of{0,1,0})
    end

    ray = renderer.raycastBlocks(position, position+vectors.of{0,0,linearVelocity.z}, "COLLIDER", "NONE")
    if ray then
        position = vectors.of{
            position.x+linearVelocity.x,
            position.y+linearVelocity.y,
            ray.pos.z - dotp(linearVelocity.z)*margin
        }
        linearVelocity = (linearVelocity * vectors.of{friction,friction,0})
    else
        position = position + (linearVelocity * vectors.of{0,0,1})
    end
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(lastPosition,position,delta)*vectors.of{-16,-16,16})
    model.NO_PARENT.setRot(vectors.lerp(lastRotation,rotation,delta)*vectors.of{-1,-1,1})
end

function dotp(x)
    return math.abs(x)/x
end