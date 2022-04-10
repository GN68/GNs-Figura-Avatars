function Ylookat(from,to)-- simple look at function, Y axis as up
    local offset = to-from
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the top surface
function collision(pos)-- sorry idk what to name this lmao
    player.getLookDir()
    local isColliding = false
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()--I HATE YELLOW
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    local currentPoint = point--for somethin idk
                    point.y =  math.floor(currentPoint.y)+value.t
                    isColliding = true
                end
            end
        end
    end
    return {result=point,isColliding=isColliding}
end

--LERP ANGLE BRUH
function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end