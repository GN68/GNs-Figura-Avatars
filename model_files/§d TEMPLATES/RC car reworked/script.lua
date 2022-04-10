--================================= [ CONFIGURATION ]

gravity = -0.05
maxThrottleSpeed = 0.08
fricion = {
    angular = 0.9,
    linear = 0.6,
}

debug = {
    controllerUpdate = false,
    substepsCount = false, --how many sub steps are done in a tick
    syncPosVelRos = false,
}
--==========[ ADVANCE CONFIG ]
substepsCap = 10
syncDelay = 20 --ticks
--================================= [ UNCHANGABLE VARIABLES ]
lastLastPosition = vectors.of{0,0,0} 
lastPosition = vectors.of{0,0,0}
position = vectors.of{0,0,0}
lastLocalVelocity = vectors.of{0,0,0}
localVelocity = vectors.of{0,0,0}

velocity = vectors.of{0,0,0}
lastRotation = 0
rotation = 0
rotationVel = 0

throttlePower = 0
steer = 0

lastDistancedTraveled = 0
distanceTraveled = 0

syncTimer = 0

vectors.ZERO = vectors.of{0,0,0}
--================================= [ CONTROLLER ]
key_throttle = keybind.newKey("Throttle","U")
key_reverse = keybind.newKey("Reverse","J")
key_turnLeft = keybind.newKey("Turn Left","H")
key_turnRight = keybind.newKey("Turn Right","K")

control = {0,0}
lastControl = {0,0}
--================================= [ NETWORK ]
ping.updateController = function (data)
    control = data
    if debug.controllerUpdate then
        log("§f[§cNETWORK§f]§r controller updated to: X="..tostring(data[1])..",Y="..tostring(data[2]))
    end
end
ping.syncPosVelRos = function (data)
    if not client.isHost() then
        position = vectors.of{data[1],data[2],data[3]}
        velocity = vectors.of{data[4],data[5],data[6]}
        rotation = data[7]
    end
    if debug.syncPosVelRos then
        log("§f[§cNETWORK§f]§r synced remote view: "..
        "\n pos §cX§f="..tostring(data[1]).." ,§aY§f="..tostring(data[2]).." ,§9Z§f="..tostring(data[4])..
        "\n vel §cX§f="..tostring(data[4]).." ,§aY§f="..tostring(data[5]).." ,§9Z§f="..tostring(data[6])..
        "\n rot §aY§f="..tostring(data[7])
    )
    end
    
end
--================================= [ GENERAL ]
function player_init()
    position = player.getPos()
end

function tick()
    
    --=========================== [ CONTROLLER ]
    control = {0,0}
    if key_throttle.isPressed() then
        control[2] = control[2] + 1
    end
    if key_reverse.isPressed() then
        control[2] = control[2] - 1
    end
    if key_turnLeft.isPressed() then
        control[1] = control[1] - 1
    end
    if key_turnRight.isPressed() then
        control[1] = control[1] + 1
    end
    if lastControl[2] ~= control[2] or lastControl[1] ~= control[1] then
        ping.updateController(control)
    end
    --=========================== [ SYNC ]
    syncTimer = syncTimer + 1
    if syncTimer > syncDelay then
        syncTimer = 0
        ping.syncPosVelRos({lastPosition.x,lastPosition.y,lastPosition.z,velocity.x,velocity.y,velocity.z,rotation})
    end
    
    --=========================== [ PHYSICS ]
    lastControl = control
    lastRotation = rotation

    lastLastPosition = lastPosition
    lastPosition = position
    
    lastLocalVelocity = localVelocity
    localVelocity = vectors.of{(math.sin(math.rad(-rotation))*velocity.z)-(math.cos(math.rad(-rotation))*velocity.x),0,(math.sin(math.rad(rotation))*velocity.x)-(math.cos(math.rad(rotation))*velocity.z)}
    
    if math.dotp(control[2]) == math.dotp(localVelocity.z) then
        throttlePower = math.lerp(throttlePower,-control[2]*maxThrottleSpeed,0.04)
    else
        throttlePower = math.lerp(throttlePower,-control[2]*maxThrottleSpeed,0.5)
    end
    
    steer = control[1]*-15

    velocity = velocity + angleToDir({0,rotation,0})*throttlePower
    rotationVel = rotationVel + steer * throttlePower
    rotationVel = rotationVel *fricion.angular
    
    rotation = rotation + rotationVel

    lastDistancedTraveled = distanceTraveled
    distanceTraveled = distanceTraveled + (velocity*vectors.of{1,0,1}).distanceTo(vectors.of{})

    local count = math.min(math.ceil(velocity.distanceTo(vectors.ZERO)-0.5)+1,substepsCap)
    if debug.substepsCount then
        log("§f[§cPHYSICS§f]§r sub-steps count: "..tostring(count))
    end
    for index = 1, count, 1 do
        local result = collision(position)
        position = position + velocity/count
        if result.isColliding then
            velocity = vectors.of{velocity.x*fricion.linear,0,velocity.z*fricion.linear}
            position = result.pos
        else
            velocity = velocity + vectors.of{0,gravity}/count
            
        end
    end
end

function world_render(delta)

    model.NO_PARENT_car.BL.setRot({math.lerp(lastDistancedTraveled,distanceTraveled,delta)*-90})
    model.NO_PARENT_car.BR.setRot({math.lerp(lastDistancedTraveled,distanceTraveled,delta)*-90})
    model.NO_PARENT_car.FL.setRot({math.lerp(lastDistancedTraveled,distanceTraveled,delta)*-90,steer})
    model.NO_PARENT_car.FR.setRot({math.lerp(lastDistancedTraveled,distanceTraveled,delta)*-90,steer})
    model.NO_PARENT_car.setPos(vectors.lerp(lastLastPosition,lastPosition,delta)*vectors.of{-16,-16,16})
    model.NO_PARENT_car.offset.setRot{0,0,math.lerp(lastLocalVelocity.x,localVelocity.x,delta)*45}
    model.NO_PARENT_car.setRot({0,math.lerp(lastRotation,rotation,delta)*-1})
end

--================================= [ COLLISION ]
function collision(point)-- sorry idk what to name this lmao
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x%1,point.y%1,point.z%1})
    local isColliding = false

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w >= blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t >= blockPos.y then
                if value.z < blockPos.z and value.h >= blockPos.z then
                    --detected inside the cube
                    point.y = math.floor(point.y)+value.t
                    isColliding = true
                end
            end
        end
    end
    return {pos=point,isColliding=isColliding}
end

function angleToDir(direction)
    if type(direction) == "table" then
        direction = vectors.of{direction}
    end
    return vectors.of({
        math.cos(math.rad(direction.y+90))*math.cos(math.rad(direction.x)),
        math.sin(math.rad(-direction.x)),
        math.sin(math.rad(direction.y+90))*math.cos(math.rad(direction.x))
    })
end

function math.dotp(x)
    return x/math.abs(x)
end