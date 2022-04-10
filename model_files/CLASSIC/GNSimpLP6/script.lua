
position = vectors.of({})
lastPosition = position

gravity = -0.1

velocity = vectors.of({})

throw = keybind.newKey("Throw","R")

function player_init()
    position = player.getPos()
end

function tick()
    lastPosition = position
    if throw.wasPressed() then
        position = player.getPos()+vectors.of({0,player.getEyeHeight()})
        velocity = player.getLookDir()*0.5
    end

    position = position + vectors.of({velocity.x,0,0})
    local col = collision(position,0)
    if col.isColliding then
        position = vectors.of({col.result.x,position.y,position.z})
        velocity.x = 0
    end


    position = position + vectors.of({0,velocity.y,0})
    local col = collision(position,1)
    if col.isColliding then
        position = vectors.of({position.x,col.result.y,position.z})
        velocity.y = 0
    end
    velocity = velocity + vectors.of({0,gravity,0})


    position = position + vectors.of({0,0,0})
    local col = collision(position,2)
    if col.isColliding then
        position = vectors.of({position.x,position.y,col.result.z})
        velocity.z = 0
    end
end

function world_render(delta)
    model.NO_PARENT.setPos(vectors.lerp(lastPosition,position,delta)*vectors.of({-16,-16,16}))
end


function collision(pos,axis)
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local isColliding = false

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local closest = 9999--used to see what is the closes face
                    local whoClosest = 0
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    
                    
                    
                    
                    
                    
                    
                    --snap the closest surfance to the point
                    if axis == 0 then
                        if math.abs(value.x-blockPos.x) < closest then
                            closest = math.abs(value.x-blockPos.x)
                            whoClosest = 0
                        end
                        if math.abs(value.w-blockPos.x) < closest then
                            closest = math.abs(value.w-blockPos.x)
                            whoClosest = 3
                        end

                        if whoClosest == 0 then
                            point.x = math.floor(currentPoint.x)+value.x
                        end
                        if whoClosest == 3 then
                            point.x =  math.floor(currentPoint.x)+value.w
                        end
                    end
                    if axis == 1 then
                        if math.abs(value.y-blockPos.y) < closest then
                            closest = math.abs(value.y-blockPos.y)
                            whoClosest = 1
                        end
                        if math.abs(value.t-blockPos.y) < closest then
                            closest = math.abs(value.t-blockPos.y)
                            whoClosest = 4
                        end

                        if whoClosest == 1 then
                            point.y = math.floor(currentPoint.y)+value.y
                        end
                        if whoClosest == 4 then
                            point.y = math.floor(currentPoint.y)+value.t
                        end
                    end

                    if axis == 2 then
                        if math.abs(value.z-blockPos.z) < closest then
                            closest = math.abs(value.z-blockPos.z)
                            whoClosest = 2
                        end
                        if math.abs(value.h-blockPos.z) < closest then
                            closest = math.abs(value.h-blockPos.z)
                            whoClosest = 5
                        end

                        if whoClosest == 2 then
                            point.z = math.floor(currentPoint.z)+value.z
                        end
                        if whoClosest == 5 then
                            point.z =  math.floor(currentPoint.z)+value.h
                        end
                    end
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end