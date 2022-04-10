stick = {}
point = {}

itterations = 4
sickLength = 2/16
strandCount = 9

airResistance = 0.95

function player_init()
    for index = 1, strandCount, 1 do
        local part = model["NO_PARENTCAPE"..tostring(index)]
        table.insert(point,{
            group=part,
            pos=player.getPos(),
            prevPos=player.getPos(),
            isLocked=false,
            id=index,
            actualPrevPos=vectors.of({})
        })
        if index ~= strandCount then
            table.insert(stick,{
                group=part,
                pos = player.getPos(),
                A=index,
                B=index+1,
            })
        end
    end
end

function toggleGroup(groupTable,toggle)
    for _, value in pairs(groupTable) do
        value.setEnabled(toggle)
    end
end



function simulation()
    --points
    for _, p in pairs(point) do
        local posBeforeUpdate = p.pos
        p.actualPrevPos = p.pos
        p.pos = p.pos+(p.pos - p.prevPos)*airResistance
        p.pos = p.pos + vectors.of({0,-0.02,0})
        p.prevPos = posBeforeUpdate
    end
    for i = 1, itterations, 1 do
        point[1].pos = player.getPos()+angleToDir({0,player.getBodyYaw()})*-0.1+vectors.of{0,player.getEyeHeight()-2/16}
        --sticks
        for i = 1, 10, 1 do
            for _, stk in pairs(stick) do
                local center = (point[stk.A].pos+point[stk.B].pos) / 2
                local dir = (point[stk.A].pos-point[stk.B].pos).normalized()
                point[stk.A].pos = center + dir * sickLength / 2
                point[stk.B].pos = center - dir * sickLength / 2
            end
        end 
    end
end

function tick()
    simulation()
end

function world_render(delta)
    --render
    for key, stk in pairs(stick) do
        stk.group.setPos(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta)*vectors.of({-16,-16,16}))
        local rot = lookat(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta),vectors.lerp(point[stk.B].prevPos,point[stk.B].pos,delta))
        stk.group.setRot(rot)
        stk.group["offset"..key].setRot({0,rot.y+player.getBodyYaw(),0})
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
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