stick = {}
point = {}

sickLength = 1
stickCount = 13

for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end
for _, v in pairs(armor_model) do
    v.setEnabled(false)
end

for index = 1, stickCount, 1 do
    table.insert(point,{
        group=model["NO_PARENT_CACTU"..tostring(index)],
        pos=vectors.of({}),
        prevPos=vectors.of({}),
        isLocked=false,
        id=index,
        actualPrevPos=vectors.of({})
    })
    if index ~= stickCount then
        table.insert(stick,{
            group=model["NO_PARENT_CACTU"..tostring(index)],
            pos = vectors.of({}),
            A=index,
            B=index+1,
        })
    end
end

function simulation()
    --points
    for key, p in pairs(point) do
        local posBeforeUpdate = p.pos
        local actualPrevPos = p.pos
        p.pos = p.pos+p.pos - p.prevPos
        p.pos = p.pos + vectors.of({0,0.04,0}) --Gravity
        posBeforeUpdate = (posBeforeUpdate-p.pos)*0.95+p.pos --Air Resistance
        p.prevPos = posBeforeUpdate
        p.actualPrevPos = actualPrevPos
        if key == stickCount then
            nameplate.ENTITY.setPos{0,p.pos.y-1,0}
        end
    end
    --sticks
    for i = 1, 10, 1 do
        for key, stk in pairs(stick) do
            local center = (point[stk.A].pos+point[stk.B].pos) / 2
            local dir = (point[stk.A].pos-point[stk.B].pos).normalized()
            point[stk.A].pos = center + dir * sickLength / 2
            point[stk.B].pos = center - dir * sickLength / 2
        end
        point[1].pos = player.getPos()
    end
end

function tick()
    simulation()
end

function world_render(delta)
    if client.isHost() then
        for key, p in pairs(point) do
            p.group.setEnabled(not renderer.isFirstPerson())
        end
    end
    --render
    for key, p in pairs(point) do
        p.group.setPos(vectors.lerp(p.prevPos,p.pos,delta)*vectors.of({-16,-16,16})) 
    end
    for key, stk in pairs(stick) do
        stk.group.setPos(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta)*vectors.of({-16,-16,16}))
        stk.group.setRot(lookat(vectors.lerp(point[stk.A].actualPrevPos,point[stk.A].pos,delta),vectors.lerp(point[stk.B].prevPos,point[stk.B].pos,delta)),delta)
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


--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface

function toLocalCoord(pos,rot)
    return vectors.of(
        {
            ((math.sin(math.rad(-rot.y))*pos.z)+(math.cos(math.rad(rot.y))*pos.x))*(math.cos(math.rad(rot.x))),
            (math.sin(math.rad(-rot.x))*pos.z)+(math.cos(math.rad(rot.x))*pos.z),
            ((math.cos(math.rad(-rot.y))*pos.z)+(math.sin(math.rad(rot.y))*pos.x))*(math.cos(math.rad(rot.x))),
        }
    )
end
