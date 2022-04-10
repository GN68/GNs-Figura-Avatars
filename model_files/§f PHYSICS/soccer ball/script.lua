--=================[ CONFIG ]=================--
margin = 0.001
gravity = vectors.of{0,-0.05,0}

friction = 0.8
bouncy = 0.3

--==================[ NO U ]==================--
linear_velocity=vectors.of{0,0,0}
angular_velocity=vectors.of{0,0,0}

lastPosition=vectors.of{}
lastRotation=vectors.of{}

lastDistanceTraveled = 0
distanceTraveled = 0

position=vectors.of{}
rotation=vectors.of{}

throw = keybind.newKey("Throw","MOUSE_BUTTON_2")

ping.throw = function()
    position = player.getPos() + vectors.of{0,player.getEyeHeight()}
    linear_velocity = player.getLookDir()*0.3
end

function tick()
    if throw.wasPressed() then
        ping.throw()
    end

    lastDistanceTraveled = distanceTraveled
    distanceTraveled = distanceTraveled + (lastPosition*vectors.of{1,0,1}).distanceTo(position*vectors.of{1,0,1})
    
    lastPosition = position
    lastRotation = rotation

    rotation = lookat(position,position+linear_velocity)
    rotation = vectors.of{distanceTraveled*-90,-rotation.y,0}

    angular_velocity = vectors.of{-linear_velocity.z,-linear_velocity.x,0}*34
    ---================================================ [ X ] 
    position = position + vectors.of{linear_velocity.x,0,0}
    linear_velocity = linear_velocity + vectors.of{gravity.x,0,0}
    
    local resultX = collisionX(position)
    if resultX.isColliding then
        position = resultX.result + vectors.of{-dotp(linear_velocity.x)*margin,0,0}--MARGIN
        linear_velocity = linear_velocity * vectors.of{-bouncy*math.abs(linear_velocity.x),friction,friction}
    end
    ---================================================ [ Y ] 
    position = position + vectors.of{0,linear_velocity.y,0}
    linear_velocity = linear_velocity + vectors.of{0,gravity.y,0}

    local resultY = collisionY(position)
    if resultY.isColliding then
        position = resultY.result + vectors.of{0,-dotp(linear_velocity.y)*margin,0}--MARGIN
        linear_velocity = linear_velocity * vectors.of{friction,-bouncy*math.abs(linear_velocity.x*10),friction}
    end
    ---================================================ [ Z ] 
    position = position + vectors.of{0,0,linear_velocity.z}
    linear_velocity = linear_velocity + vectors.of{0,0,gravity.z}
    
    local resultZ = collisionZ(position)
    if resultZ.isColliding then
        position = resultZ.result + vectors.of{0,0,-dotp(linear_velocity.z)*margin}--MARGIN
        linear_velocity = linear_velocity * vectors.of{friction,friction,-bouncy*math.abs(linear_velocity.x)}
    end

    rotation = rotation + angular_velocity
end

function world_render(delta)
    model.NO_PARENT_BALL.setPos((vectors.lerp(lastPosition,position,delta)+vectors.of{0,0.5,0})*vectors.of{-16,-16,16})
    model.NO_PARENT_BALL.setRot(vectors.lerp(lastRotation,rotation,delta)*vectors.of{-1,-1,1})
end

function collisionX(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local isColliding = false
    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x <= blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y <= blockPos.y and value.t > blockPos.y then
                if value.z <= blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.x-blockPos.x) < closest then
                        closest = math.abs(value.x-blockPos.x)
                        whoClosest = false
                    end
                    if math.abs(value.w-blockPos.x) < closest then
                        closest = math.abs(value.w-blockPos.x)
                        whoClosest = true
                    end
                    --snap the closest surfance to the point
                    if whoClosest == false then
                        point.x = math.floor(currentPoint.x)+value.x
                    end
                    if whoClosest == true then
                        point.x =  math.floor(currentPoint.x)+value.w
                    end
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end


function collisionY(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local isColliding = false
    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x <= blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y <= blockPos.y and value.t > blockPos.y then
                if value.z <= blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.y-blockPos.y) < closest then
                        closest = math.abs(value.y-blockPos.y)
                        whoClosest = false
                    end
                    if math.abs(value.t-blockPos.y) < closest then
                        closest = math.abs(value.t-blockPos.y)
                        whoClosest = true
                    end
                    --snap the closest surfance to the point
                    if whoClosest == false then
                        point.y = math.floor(currentPoint.y)+value.y
                    end
                    if whoClosest == true then
                        point.y =  math.floor(currentPoint.y)+value.t
                    end
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end

function collisionZ(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local isColliding = false
    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x <= blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y <= blockPos.y and value.t > blockPos.y then
                if value.z <= blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    if math.abs(value.z-blockPos.z) < closest then
                        closest = math.abs(value.z-blockPos.z)
                        whoClosest = false
                    end
                    if math.abs(value.h-blockPos.z) < closest then
                        closest = math.abs(value.h-blockPos.z)
                        whoClosest = true
                    end
                    --snap the closest surfance to the point
                    if whoClosest == false then
                        point.z = math.floor(currentPoint.z)+value.z
                    end
                    if whoClosest == true then
                        point.z =  math.floor(currentPoint.z)+value.h
                    end
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end

function dotp(x)
    return math.abs(x)/x
end
-- UP IS Y
function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end