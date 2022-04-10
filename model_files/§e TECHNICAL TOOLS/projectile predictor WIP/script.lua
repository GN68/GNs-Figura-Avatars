
itterations = 200

function tick()
    if player.getHeldItem(1) then
        if player.getHeldItem(1).getType() == "minecraft:bow" then
            local position = vectors.of{player.getPos().x,player.getPos().y+player.getEyeHeight(),player.getPos().z}
            local velocity = player.getLookDir()*sec2tick(60.5)
            for time = 1, itterations, 1 do
                velocity = velocity - vectors.of{0,0.064,0}
                position = position + velocity
                particle.addParticle("minecraft:dust",position,{1,1,0,1})
            end
        end
    end
end

function sec2tick(x)
    return x/20
end