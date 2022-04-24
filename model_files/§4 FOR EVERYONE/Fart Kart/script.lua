--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--]]

vectors.toWorldPos = vectors.of{-16,-16,16}
vectors.toWorldRot = vectors.of{-1,-1,1}

isRidingMinecart = false
lastVehicleRot = vectors.of{}
vehicleRot = vectors.of{90,0,0}
speed = 0
distTraveled = 0

function tick()
    distTraveled = distTraveled% 100
    if player.getVehicle() then
        speed = player.getVehicle().getVelocity().getLength()
        if speed > 0.01 then
            vehicleRot = math.toAngle(player.getVehicle().getVelocity())
        end
        
        isRidingMinecart = player.getVehicle().getType() == "minecraft:minecart"
    else
        isRidingMinecart = false
    end
    renderer.setMountEnabled(not isRidingMinecart)
    model.NO_PARENT.setEnabled(isRidingMinecart)
    vanilla_model.LEFT_LEG.setEnabled(not isRidingMinecart)
    vanilla_model.RIGHT_LEG.setEnabled(not isRidingMinecart)
    vanilla_model.LEFT_PANTS_LEG.setEnabled(not isRidingMinecart)
    vanilla_model.RIGHT_PANTS_LEG.setEnabled(not isRidingMinecart)
end

function world_render(delta)
    if isRidingMinecart and player.getVehicle() then
        distTraveled = distTraveled + speed
        if speed > 0.2 then
            for i = 1, 2, 1 do
                particle.addParticle("minecraft:splash",player.getVehicle().getPos()+vectors.of{math.cos(math.rad(vehicleRot.y))*0.3,0.8,-math.sin(math.rad(vehicleRot.y))*0.3})
                particle.addParticle("minecraft:splash",player.getVehicle().getPos()+vectors.of{math.cos(math.rad(vehicleRot.y))*-0.3,0.8,-math.sin(math.rad(vehicleRot.y))*-0.3})
            end
        end
        local smoothness = 0.3
        lastVehicleRot = vectors.of{
            lerp_angle(lastVehicleRot.x, vehicleRot.x, smoothness),
            lerp_angle(lastVehicleRot.y, vehicleRot.y, smoothness),
            lerp_angle(lastVehicleRot.z, vehicleRot.z, smoothness)
        }
        model.NO_PARENT.BASE.wheel1.setRot{math.deg(distTraveled)%90-90,0,0}
        model.NO_PARENT.BASE.wheel2.setRot{math.deg(distTraveled)%90-90,0,0}
        model.NO_PARENT.BASE.wheel3.setRot{math.deg(distTraveled)%90-90,0,0}
        model.NO_PARENT.BASE.wheel4.setRot{math.deg(distTraveled)%90-90,0,0}
        model.NO_PARENT.setRot(lastVehicleRot)
        model.NO_PARENT.setPos((player.getVehicle().getPos(delta)+vectors.of{0,math.abs(math.sin(distTraveled*2))*0.05})*vectors.toWorldPos)
        for _, value in pairs(vanilla_model) do
            value.setPos(vectors.of{0,-2+math.sin((distTraveled+1)*4)*-0.5})
        end
    end
end

function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end

function math.toAngle(pos)
    local y = math.atan2(pos.x,pos.z)
    local result = vectors.of({math.atan2((math.sin(y)*pos.x)+(math.cos(y)*pos.z),pos.y),y})
    return vectors.of({math.deg(result.x),math.deg(result.y),math.deg(result.z)})
end