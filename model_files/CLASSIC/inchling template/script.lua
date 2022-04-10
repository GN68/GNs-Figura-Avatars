for key, value in pairs(vanilla_model) do
    value.setEnabled(false)    
end

for key, value in pairs(armor_model) do
    value.setEnabled(false)
end

function render(delta)
   if vanilla_model.TORSO.getOriginRot()[1] == 0.5 then
       model.LeftLeg.setPos({0,0,2.5})
       model.RightLeg.setPos({0,0,2.5})
	   model.MIMIC_LEFT_ARM.setPos({0,25,3})
       model.MIMIC_RIGHT_ARM.setPos({0,25,3})
	   model.MIMIC_HEAD.LEFT_PARROT.setPos({-6,-65,0})
	   model.MIMIC_HEAD.RIGHT_PARROT.setPos({6,-65,0})
	   model.MIMIC_HEAD.setPos({0,26,2})
	   model.MIMIC_RIGHT_ARM.bone.rightHeld.setScale({2,2,2})
	   model.MIMIC_LEFT_ARM.bone2.leftHeld.setScale({2,2,2})
   else
       model.LeftLeg.setPos({0,0,0})
       model.RightLeg.setPos({0,0,0})
	   model.MIMIC_LEFT_ARM.setPos({0,24,0})
       model.MIMIC_RIGHT_ARM.setPos({0,24,0})
	   model.MIMIC_HEAD.LEFT_PARROT.setPos({-6,-64,0})
	   model.MIMIC_HEAD.RIGHT_PARROT.setPos({6,-64,0})
	   model.MIMIC_HEAD.setPos({0,24,0})
	   model.MIMIC_RIGHT_ARM.bone.rightHeld.setScale({2,2,2})
	   model.MIMIC_LEFT_ARM.bone2.leftHeld.setScale({2,2,2})
	end

	if not player.getHeldItem(1)then
		first_person_model.MAIN_HAND.setPos({-2,-6,0})
		first_person_model.MAIN_HAND.setRot({0,0,8})
	else
		first_person_model.MAIN_HAND.setPos({0,0,0})
		first_person_model.MAIN_HAND.setRot({0,0,0})
	end
end

--texture height and width

texture_height = 256
texture_width = 128


--armor table and function
armor = {
head = { model.MIMIC_HEAD.Helmet },
chest = { model.Body.chest, model.MIMIC_RIGHT_ARM.bone.chest, model.MIMIC_LEFT_ARM.bone2.chest },
legs = { model.Body.leggings, model.LeftLeg.leggings, model.RightLeg.leggings },
boots = { model.LeftLeg.boots, model.RightLeg.boots }
}

armor.head[1].setEnabled(false)

--custom armor function
function update_armor(armor_table, x, table_vector)
    for key, value in pairs(armor_table) do
        value[x](table_vector)
    end
end

function tick()
    custom_armor()
end

function custom_armor()
    local boots = player.getEquipmentItem(3).getType()
    local legs = player.getEquipmentItem(4).getType()
    local chest = player.getEquipmentItem(5).getType()
    local head = player.getEquipmentItem(6).getType()
    --head
    update_armor(armor.head, "setColor", {1, 1, 1})
    if head == "minecraft:air" then
        update_armor(armor.head, "setEnabled", false)
    else
        update_armor(armor.head, "setEnabled", true)
    end

    if player.getEquipmentItem(6).hasGlint() then
        update_armor(armor.head, "setShader", "Glint")
    else
        update_armor(armor.head, "setShader", "None")
    end

    if head == "minecraft:turtle_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, -34/texture_height})
    elseif head == "minecraft:netherite_helmet" then
        update_armor(armor.head, "setUV", {50/texture_width, 80/texture_height})
    elseif head == "minecraft:diamond_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 40/texture_height})
    elseif head == "minecraft:iron_helmet" then
        update_armor(armor.head, "setUV", {0, 0})
    elseif head == "minecraft:golden_helmet" then
        update_armor(armor.head, "setUV", {50/texture_width, 0/texture_height})
    elseif head == "minecraft:chainmail_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 80/texture_height})
    elseif head == "minecraft:leather_helmet" then
        update_armor(armor.head, "setUV", {50/texture_width, 40/texture_height})
        if player.getEquipmentItem(6).getTag() ~= nil and player.getEquipmentItem(6).getTag().display ~= nil and player.getEquipmentItem(6).getTag().display.color ~= nil then
            update_armor(armor.head, "setColor", vectors.intToRGB(player.getEquipmentItem(6).getTag().display.color))
        else
            update_armor(armor.head, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --chest
    update_armor(armor.chest, "setColor", {1, 1, 1})
    if chest == "minecraft:air" then
        update_armor(armor.chest, "setEnabled", false)
    else
        update_armor(armor.chest, "setEnabled", true)
    end

    if player.getEquipmentItem(5).hasGlint() then
        update_armor(armor.chest, "setShader", "Glint")
    else
        update_armor(armor.chest, "setShader", "None")
    end

    if chest == "minecraft:netherite_chestplate" then
        update_armor(armor.chest, "setUV", {50/texture_width, 80/texture_height})
    elseif chest == "minecraft:diamond_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 40/texture_height})
    elseif chest == "minecraft:iron_chestplate" then
        update_armor(armor.chest, "setUV", {0, 0})
    elseif chest == "minecraft:golden_chestplate" then
        update_armor(armor.chest, "setUV", {50/texture_width, 0/texture_height})
    elseif chest == "minecraft:chainmail_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 80/texture_height})
    elseif chest == "minecraft:leather_chestplate" then
        update_armor(armor.chest, "setUV", {50/texture_width, 40/texture_height})
        if player.getEquipmentItem(5).getTag() ~= nil and player.getEquipmentItem(5).getTag().display ~= nil and player.getEquipmentItem(5).getTag().display.color ~= nil then
            update_armor(armor.chest, "setColor", vectors.intToRGB(player.getEquipmentItem(5).getTag().display.color))
        else
            update_armor(armor.chest, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --legs
    update_armor(armor.legs, "setColor", {1, 1, 1})
    if legs == "minecraft:air" then
        update_armor(armor.legs, "setEnabled", false)
    else
        update_armor(armor.legs, "setEnabled", true)
    end

    if player.getEquipmentItem(4).hasGlint() then
        update_armor(armor.legs, "setShader", "Glint")
    else
        update_armor(armor.legs, "setShader", "None")
    end

    if legs == "minecraft:netherite_leggings" then
        update_armor(armor.legs, "setUV", {50/texture_width, 80/texture_height})
    elseif legs == "minecraft:diamond_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 40/texture_height})
    elseif legs == "minecraft:iron_leggings" then
        update_armor(armor.legs, "setUV", {0, 0})
    elseif legs == "minecraft:golden_leggings" then
        update_armor(armor.legs, "setUV", {50/texture_width, 0/texture_height})
    elseif legs == "minecraft:chainmail_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 80/texture_height})
    elseif legs == "minecraft:leather_leggings" then
        update_armor(armor.legs, "setUV", {50/texture_width, 40/texture_height})
        if player.getEquipmentItem(4).getTag() ~= nil and player.getEquipmentItem(4).getTag().display ~= nil and player.getEquipmentItem(4).getTag().display.color ~= nil then
            update_armor(armor.legs, "setColor", vectors.intToRGB(player.getEquipmentItem(4).getTag().display.color))
        else
            update_armor(armor.legs, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --boots
    update_armor(armor.boots, "setColor", {1, 1, 1})
    if boots == "minecraft:air" then
        update_armor(armor.boots, "setEnabled", false)
    else
        update_armor(armor.boots, "setEnabled", true)
    end

    if player.getEquipmentItem(3).hasGlint() then
        update_armor(armor.boots, "setShader", "Glint")
    else
        update_armor(armor.boots, "setShader", "None")
    end

    if boots == "minecraft:netherite_boots" then
        update_armor(armor.boots, "setUV", {50/texture_width, 80/texture_height})
    elseif boots == "minecraft:diamond_boots" then
        update_armor(armor.boots, "setUV", {0/texture_width, 40/texture_height})
    elseif boots == "minecraft:iron_boots" then
        update_armor(armor.boots, "setUV", {0, 0})
    elseif boots == "minecraft:golden_boots" then
        update_armor(armor.boots, "setUV", {50/texture_width, 0/texture_height})
    elseif boots == "minecraft:chainmail_boots" then
        update_armor(armor.boots, "setUV", {0/texture_width, 80/texture_height})
    elseif boots == "minecraft:leather_boots" then
        update_armor(armor.boots, "setUV", {50/texture_width, 40/texture_height})
        if player.getEquipmentItem(3).getTag() ~= nil and player.getEquipmentItem(3).getTag().display ~= nil and player.getEquipmentItem(3).getTag().display.color ~= nil then
            update_armor(armor.boots, "setColor", vectors.intToRGB(player.getEquipmentItem(3).getTag().display.color))
        else
            update_armor(armor.boots, "setColor", {134/255 , 82/255 , 53/255})
        end
    end
end