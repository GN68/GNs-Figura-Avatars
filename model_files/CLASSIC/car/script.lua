

function tick()
    if player.getVehicle() ~= nil and (player.getVehicle().getType() == "minecraft:horse" or player.getVehicle().getType() == "minecraft:skeleton_horse" or player.getVehicle().getType() == "minecraft:zombie_horse" or player.getVehicle().getType() == "minecraft:donkey" or player.getVehicle().getType() == "minecraft:mule")then
        renderer.setMountEnabled(false)
        vehicleMode(false)
     else
         renderer.setMountEnabled(true)
         vehicleMode(true)
     end
end

model.Base.setPos({0,33,0})
model.Base.setRot({0,180,0})

function vehicleMode(is)
    for key, value in pairs(vanilla_model) do
        value.setEnabled(is)    
    end
    for key, value in pairs(armor_model) do
        value.setEnabled(is)    
    end
    for key, value in pairs(model) do
        value.setEnabled((not is))    
    end
    if is then
        
    end
end