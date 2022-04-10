
time = 0

attack = keybind.getRegisteredKeybind("key.attack")
attackWasPressed = false

projIndex = {}



projPos = {}
projVel = {}

currentlyShot = 0
timeSinceLastShot = 0

Count = 1

function player_init()
    for i = 1, 10, 1 do
        table.insert(projIndex,model.NO_PARENT["fireball"..i])
        table.insert(projPos,vectors.of({0,0,0}))
        table.insert(projVel,vectors.of({0,0,0}))
    end
end

function tick()
    timeSinceLastShot = timeSinceLastShot + 1
    time = time + 1
    for index, fireball in pairs(projIndex) do
            projPos[index] = projPos[index] + projVel[index]

        if attack.isPressed() then
            if not attackWasPressed then--shoot
                projPos[currentlyShot+1] = player.getPos()+vectors.of({0,player.getEyeHeight()})+player.getLookDir()
                projVel[currentlyShot+1] = player.getLookDir()*0.5
                currentlyShot = (currentlyShot + 1)%10
                timeSinceLastShot = 0
            end
        end
        attackWasPressed = attack.isPressed()
        if not string.find(world.getBlockState(projPos[index]).name,"air") then
            chat.sendMessage("/summon creeper "..projPos[index].x-projVel[index].x.." "..projPos[index].y-projVel[index].y.." "..projPos[index].z-projVel[index].z.." {Fuse:-1,ExplosionRadius:8}")
            projPos[index] = vectors.of({0,-999,0})
            projVel[index] = vectors.of({0,0,0})
        end
    end
end

function world_render(delta)
    model.RIGHT_ARM.fireballHand.setRot({(time+delta)*10,(time+delta)*11,0})
    for index, fireball in pairs(projIndex) do
        local pos = vectors.of({
            lerp(projPos[index].x,projPos[index].x+projVel[index].x,delta),
            lerp(projPos[index].y,projPos[index].y+projVel[index].y,delta),
            lerp(projPos[index].z,projPos[index].z+projVel[index].z,delta),
        })
        fireball.setPos(pos*vectors.of({-16,-16,16}))
        fireball.setRot({(time+delta)*10,(time+delta)*10,0})
        particle.addParticle("minecraft:smoke",vectors.of({pos.x,pos.y,pos.z}))
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end