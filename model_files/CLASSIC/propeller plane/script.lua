linearVelocity = vectors.of({})
angularVelocity = vectors.of({})
lastAngularVelocity = angularVelocity

position = vectors.of({})
lastPosition = position

rotation = vectors.of({})
lastRotation = vectors.of({})

propeller = 0
throttle = 0
maxSpeed = 3

gravity = 0.1

YawSensitivity = 0.2
pitchSensitivity = 0.2
tiltSensitivity = -10

keyForward = keybind.newKey("Throttle up","Y")
keyStop = keybind.newKey("Throttle down","I")

keyYawRight = keybind.newKey("Yaw Right","K")
keyYawLeft = keybind.newKey("Yaw Left","H")
keyPitchUp = keybind.newKey("Pitch up","U")
keyPitchDown = keybind.newKey("Pitch down","J")


action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:ender_pearl"))
action_wheel.SLOT_1.setFunction(function ()
    position = player.getPos()
    rotation = vectors.of({0,player.getRot().y+180})
    sound.playSound("minecraft:entity.item.pickup",position,{1,0.5})
end)


function player_init()
    position = player.getPos()
    rotation = vectors.of({0,player.getRot().y+180})
end

function tick()
    model.HUD.setPos(client.getWindowSize()/vectors.of({-2,2})/8)
    model.HUD.control.setPos({0,lerp(0,-18.5,throttle)})

    lastAngularVelocity = angularVelocity
    if keyForward.isPressed() then
        throttle = math.min(throttle + 0.01,1)
    end
    if keyStop.isPressed() then
        throttle = math.max(throttle - 0.02,0)
    end
    if keyYawLeft.isPressed() then
        angularVelocity = angularVelocity - vectors.of({0,YawSensitivity})
    end

    if keyYawRight.isPressed() then
        angularVelocity = angularVelocity + vectors.of({0,YawSensitivity})
    end

    if keyPitchUp.isPressed() then
        angularVelocity = angularVelocity - vectors.of({pitchSensitivity,0,0})
    end

    if keyPitchDown.isPressed() then
        angularVelocity = angularVelocity + vectors.of({pitchSensitivity,0,0})
    end

    lastPosition = position
    position = position + linearVelocity
    position = position + vectors.of({0,lerp(-gravity,0,throttle)})
    local col = collision(position+vectors.of({0,0.01,0}))
    if col.isColliding then
        --position = ((position-lastPosition)*((col.normal*-1)+vectors.of({1,1,1})))+lastPosition
        position = col.result
        rotation = rotation * vectors.of({0.88,1,1})
    end

    lastRotation =  rotation
    rotation = rotation + angularVelocity

    angularVelocity = angularVelocity * 0.95
    linearVelocity = model.NO_PARENT_CONTROLS.partToWorldPos(vectors.of({0,0,-throttle*maxSpeed}))
    
end

function world_render(delta)
    propeller = propeller + throttle*120
    model.NO_PARENT.TILT.propeller.setRot({0,0,propeller})
    model.NO_PARENT.setPos(vectors.lerp(lastPosition,position,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.setRot(vectors.lerp(lastRotation,rotation,delta) * vectors.of({-1,-1,1}))
    model.NO_PARENT_CONTROLS.setRot(rotation)
    model.NO_PARENT.TILT.setRot({0,0,lerp(lastAngularVelocity.y,angularVelocity.y,delta)*tiltSensitivity})
end

function lerp(a, b, x)
    return a + (b - a) * x
end

--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local isColliding = false
    local normal = vectors.of({0,0,0})
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    isColliding = true
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.x-blockPos.x) < closest then
                        closest = math.abs(value.x-blockPos.x)
                        whoClosest = 0
                        normal = vectors.of({1,0,0})
                    end
                    if math.abs(value.y-blockPos.y) < closest then
                        closest = math.abs(value.y-blockPos.y)
                        whoClosest = 1
                        normal = vectors.of({0,1,0})
                    end
                    if math.abs(value.z-blockPos.z) < closest then
                        closest = math.abs(value.z-blockPos.z)
                        whoClosest = 2
                        normal = vectors.of({0,0,1})
                    end
                    
                    if math.abs(value.w-blockPos.x) < closest then
                        closest = math.abs(value.w-blockPos.x)
                        whoClosest = 3
                        normal = vectors.of({1,0,0})
                    end
                    if math.abs(value.t-blockPos.y)-5 < closest then
                        closest = math.abs(value.t-blockPos.y)
                        whoClosest = 4
                        normal = vectors.of({0,1,0})
                    end
                    if math.abs(value.h-blockPos.z) < closest then
                        closest = math.abs(value.h-blockPos.z)
                        whoClosest = 5
                        normal = vectors.of({0,0,1})
                    end
                    
                    point.y = math.floor(currentPoint.y)+value.t
                end
            end
        end
    end
    return {result=point,isColliding=isColliding,normal=normal}
end