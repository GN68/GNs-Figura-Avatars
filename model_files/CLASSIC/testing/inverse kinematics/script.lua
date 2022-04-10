
posA = vectors.of({})
posB = vectors.of({})

function world_render()
    posB = player.getPos()
    ik(model.NO_PARENT.Base.FRA,model.NO_PARENT.FRB)
    model.NO_PARENT.FRB.setPos(posB*vectors.of({-16,-16,16}))
end

function lookat(a,b)
    local offset = b-a
    local y = math.atan2(offset.x,offset.z)
    local result = vectors.of({math.atan2((math.sin(y)*offset.x)+(math.cos(y)*offset.z),offset.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end

function ik(modelA,modelB)
    modelA.setRot(lookat(modelA.getPos()/vectors.of({16,16,16}),modelB.partToWorldPos({0,16,0}))*vectors.of({-1,-1,1}))
    modelB.setRot(lookat(modelB.getPos()/vectors.of({-16,-16,16}),modelA.partToWorldPos({0,-16,0})+vectors.of({0,-1,0})))
end