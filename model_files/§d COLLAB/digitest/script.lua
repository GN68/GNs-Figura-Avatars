
texture_height = 512
texture_width = 512
--SCALE CHANGE TO FIX INVENTORY CLIPPING HOPEFULLY MAYBE
--function tick()
--   if client.getOpenScreen()== "Crafting" or client.getOpenScreen()== "class_481" then
--           model.base.setScale({.75,.75,.75})
--   else
--       model.base.setScale{1,1,1}
--   end
--end


-- 3D Hat Layer
model.base.Head.ThreeDHat.setScale({1.18,1.18,1.18})
--function tick()
--    local time = world.getTime()
--    model.base.BodyDigitigrade.BodyBlink.setUV({math.floor((time/2))/2,0})
--end
--model.base.Head.HelmetFuture.setScale({1.2,1.2,1.2})


-- Torso Blink Animation Setup
frames = {
    {0,0},     -- closed torso eye
    {8/512,0}, -- half closed eye
    {16/512,0}, -- half closed eye w. emissive
    {24/512,0}, -- wide open w. emissive
    {32/512,0}, -- wide open w. emissive frame 2
    {40/512,0}, -- half closed w. emissive
    {48/512,0}, -- half closed eye
    {56/512,0}, -- closed torso eye
}

framesLeftTorsoFlank = {
    {0,0},     -- closed torso eye
    {4/512,0}, -- half closed eye
    {8/512,0}, -- half closed eye w. emissive
    {12/512,0}, -- wide open w. emissive
    {16/512,0}, -- wide open w. emissive frame 2
    {20/512,0}, -- half closed w. emissive
    {24/512,0}, -- half closed eye
    {28/512,0}, -- closed torso eye
}

time = 1
nextBlink = 0

--action_wheel.SLOT_2.setFunction.(function tick() if time > 8 then time = 1 nextBlink = world.getTime() + math.random(15,250) end model.Body.BodyBlink.setUV(frames[time]) if nextBlink < world.getTime() then time = time + 1 end end)

function tick()
    if time > 8 then
        time = 1
        nextBlink = world.getTime() + math.random(15,250)
    end
    model.base.BodyDigitigrade.TorseDigi.BodyBlinkFront.setUV(frames[time])
    if nextBlink < world.getTime() then
        time = time + 1
    end
end


--Face Blink Animation Setup

frames2 = {
    {0,0},     -- closed torso eye
    {8/texture_width,0}, -- half closed eye
    {16/texture_width,0}, -- half closed eye w. emissive
    {24/texture_width,0}, -- wide open w. emissive
    {32/texture_width,0}, -- wide open w. emissive frame 2
    {40/texture_width,0}, -- half closed w. emissive
    {48/texture_width,0}, -- half closed eye
    {56/texture_width,0}, -- closed torso eye
}

time2 = 1
nextBlink2 = 0

function tick()
    if time2 > 8 then
        time2 = 1
        nextBlink2 = world.getTime() + math.random(15,80)
    end
    model.base.Head.Face.setUV(frames2[time2])
    if nextBlink2 < world.getTime() then
        time2 = time2 + 1
    end
end

--Hide Right Leg
vanilla_model.RIGHT_LEG.setEnabled(false)

--Enderman Arm Test
vanilla_model.LEFT_ARM.setEnabled(false)


--EnderArm GlowCore Animation Test

frames3 = {
    {0,0},   
    {8/64,0},
    {16/64,0}, 
    {24/64,0}, 
    {32/64,0}, 
    {10/64,0}, 
    {12/64,0}, 
    {14/64,0},
    {16/64,0},
    {18/64,0},
    {20/64,0},
    {22/64,0},
    {24/64,0},
    {26/64,0},
    {28/64,0},
    {30/64,0},
}

time3 = 1
nextBlink3 = 0


toggle = false
-- Arm Toggle

--
--
-- BODY PART RENDERING OPTIONS
--
--
--Hide Left Leg
vanilla_model.LEFT_LEG.setEnabled(false)
--Digitigrade Leg Test
vanilla_model.RIGHT_LEG.setEnabled(false)
--Hide Normal Torso
vanilla_model.TORSO.setEnabled(true)
model.base.Body.BodyBlink.setEnabled(true)
--Enderman Arm Test
vanilla_model.LEFT_ARM.setEnabled(false)


--EnderArm GlowCore Toggle
function ping.GlowCoreToggle(x)
    model.base.LeftArm.EnderArm.GlowCore.setEnabled(x)
end
--action_wheel.SLOT_3.setItem("minecraft:nether_star")
--action_wheel.SLOT_3.setFunction(function() toggle = not toggle ping.GlowCoreToggle(toggle) end)
-- Arm Toggle
function ping.VanillaArmToggle(x)
    vanilla_model.LEFT_ARM.setEnabled(x)
end
--action_wheel.SLOT_2.setItem("minecraft:ender_eye")
--action_wheel.SLOT_2.setFunction(function() toggle = not toggle ping.VanillaArmToggle(toggle) end)

armor_model.HELMET.setEnabled(false)
armor_model.LEGGINGS.setEnabled(false)
armor_model.BOOTS.setEnabled(false)


--
--
-- THIS IS THE DIGITIGRADE ARMOUR SCRIPT PART
--
--
-- turn off model

for key, value in pairs(vanilla_model) do
    value.setEnabled(false)
end

for key, value in pairs(armor_model) do
    value.setEnabled(false)
end

for key, value in pairs(elytra_model) do
    value.setEnabled(false)
end

--
--underarmor alias table

-----------------------------------------
-----------------------------------------
---------------ALIAS TABLE---------------
-----------------------------------------
-----------------------------------------

underhelmet = {model.base.Head.Helmet.underhelmet}


--armor alias table

--armor = {
--    model.base.Head.Helmet,
--    model.base.Body.chest,
--    model.base.RightLeg.rightlegarmor,
 --   model.base.LeftLeg.leftlegarmor,
 --   model.base.RightLeg.boots,
 --   model.base.LeftLeg.boots
--}


--underarmor alias table

underarmor = {
    model.base.Body.clothesbody,
    --model.base.BodyDigitigrade.clothesbody2,
 --   model.base.LeftArm.clothesleftarm,
   -- model.base.RightArm.clothesrightarm,
    model.base.LeftLeg.clothesleftleg,
    model.base.RightLeg.clothesrightleg,
    model.base.BodyDigitigrade.clothesbody2
}

--underarmor arms alias table

underarmorarms = {
    model.base.LeftArm.clothesleftarm,
    model.base.RightArm.clothesrightarm
}

--calves alias table

calves = {
    model.base.RightLeg.calf2,
    model.base.LeftLeg.calf
}
    --paws = {}


--for i,v in ipairs(underarmor) do
--   v.setEnabled(true)
--end
--function ping.Clothestoggle(x)
  --  model.base.Body.clothesbody.setEnabled(x)
  --  model.base.LeftArm.clothesleftarm.setEnabled(x)
  --  model.base.RightArm.clothesrightarm.setEnabled(x)
  --  model.base.LeftLeg.clothesleftleg.setEnabled(x)
    --model.base.RightLeg.clothesrightleg.setEnabled(x)
--end

-- main underarmor toggle


--function ping.Clothestoggle(b)
    --for i,v in ipairs(underarmor) do
        --v.setEnabled(b)
    --end
--end
--function ping.Calftoggle(y)
    --for a,b in ipairs(calves) do
        --b.setEnabled(y)
    --end
--end

--under helmet toggle 

--function ping.Underhelmtoggle(z)
--    model.base.Head.Helmet.underhelmet.setEnabled(z)
--end

-- switch underarmor calves and underhelmet to green

colors = {
    red={200/255,40/255,40/255},
    green={80/255,255/255,80/255},
    blue={80/255,255/255,80/255},
    white={1,1,1},
    brown={160/255,120/255,102/255},
    black={0,0,0}

}

function ping.Clothes(color)
    for i,v in ipairs(underarmor) do
        v.setColor(colors[color])
    end
    for i,v in ipairs(underarmorarms) do
        v.setColor(colors[color])
    end
end

function ping.Calves(color)
    for i,v in ipairs(calves) do
        v.setColor(colors[color])
    end
end

--switch underarmor calves and underhelmet to blue
--function ping.ClothesCream()
  --  for i,v in ipairs(underarmor) do
    --    v.setUV({81/texture_width,0/texture_height})
    --end
    --for i,v in ipairs(calves) do
 --       v.setUV({81/texture_width,0/texture_height})
--    end
 --   for i,v in ipairs(underarmorarms) do
--        v.setUV({81/texture_width,0/texture_height})
--    end
    --model.base.Head.Helmet.underhelmet.setUV({81/texture_width,0/texture_width})
--end

--switch underarmor calves and underhelmet to black
--underhelmet render toggle

--togglehelmet = false
--action_wheel.SLOT_1.setItem("minecraft:leather_helmet")
--action_wheel.SLOT_1.setTitle("Toggle Underhelmet Rendering")
--action_wheel.SLOT_1.setFunction(function()
--    togglehelmet = not togglehelmet
--    for i,v in ipairs(underhelmet) do
--        v.setEnabled(togglehelmet)
--    end
--end)

--underclothes render toggle

--underclothes arm toggle
togglearms = true



--RIPOFF OF MERMAID ALEX BASE BY NYRIUM

function player_init()
	lastpos = player.getPos()
end




--ACTION SLOT ARMOUR AND UNDERARMOUR TOGGLE CONFIGURATION
--REPLACES OLD ONE WITH ONE RIPPED OFF FROM MERMAID ALEX BASE BY NYRIUM
--COMMENT THIS SHIT OUT AND UNCOMMENT THE OTHER SHIT TO GO BACK TO WORSE SYSTEM M'KAY?
--  SIGNED, ROMAIN


armored = true

word1 = "Visible"
item1 = item_stack.createItem("minecraft:leather_chestplate")
item1.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
action_wheel.SLOT_1.setTitle("Armour "..word1)
action_wheel.SLOT_1.setItem(item1)
action_wheel.SLOT_1.setFunction(
function() 
	--sound.playSound("minecraft:item.armor.equip_generic", {playerPos.x,playerPos.y,playerPos.z, 0.75, 1}) 
	armored = not armored
	if not armored then
		word1 = "Invisible"
		item1.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
	else
		word1 = "Visible"
		item1.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
	end
	action_wheel.SLOT_1.setTitle("Armour "..word1)
	action_wheel.SLOT_1.setItem(item1)
	ping.armorSwitch(armored)
end)





underarmored = true

word2 = "Visible"
item2 = item_stack.createItem("minecraft:leather_leggings")
item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
action_wheel.SLOT_2.setTitle("Underarmour "..word2)
action_wheel.SLOT_2.setItem(item2)
action_wheel.SLOT_2.setFunction(
function() 
	--sound.playSound("minecraft:item.armor.equip_generic", {playerPos.x,playerPos.y,playerPos.z, 0.75, 1}) 
	underarmored = not underarmored
	if not underarmored then
		word2 = "Invisible"
		item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
	else
		word2 = "Visible"
		item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
	end
	action_wheel.SLOT_2.setTitle("Underarmour "..word2)
	action_wheel.SLOT_2.setItem(item2)
	ping.underarmorSwitch(underarmored)
end)

function underarmorSwitch(val)
    
	underarmored = val
    model.base.Body.clothesbody.setEnabled(underarmored)
    model.base.BodyDigitigrade.clothesbody2.setEnabled(underarmored)
    --model.base.BodyMermaid.clothesbody2.setEnabled(underarmored)
    model.base.LeftArm.clothesleftarm.setEnabled(underarmored)
    model.base.RightArm.clothesrightarm.setEnabled(underarmored)
    model.base.LeftLeg.clothesleftleg.setEnabled(underarmored)
    model.base.RightLeg.clothesrightleg.setEnabled(underarmored)
	--armor_model.HELMET.setEnabled(armored)
	--armor_model.HEAD_ITEM.setEnabled(armored)
	--armor_model.CHESTPLATE.setEnabled(armored)
end






undercalves = true

word3 = "Visible"
item3 = item_stack.createItem("minecraft:leather_boots")
item3.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
action_wheel.SLOT_3.setTitle("Undercalves "..word3)
action_wheel.SLOT_3.setItem(item3)
action_wheel.SLOT_3.setFunction(
function() 
	--sound.playSound("minecraft:item.armor.equip_generic", {playerPos.x,playerPos.y,playerPos.z, 0.75, 1}) 
	undercalves = not undercalves
	if not undercalves then
		word3 = "Invisible"
		item3.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
	else
		word3 = "Visible"
		item3.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
	end
	action_wheel.SLOT_3.setTitle("Undercalves "..word3)
	action_wheel.SLOT_3.setItem(item3)
	ping.undercalvesSwitch(undercalves)
end)

function undercalvesSwitch(valo)
	undercalves = valo
    model.base.LeftLeg.calf.LeftCalf.setEnabled(undercalves)
    model.base.RightLeg.calf2.RightCalf.setEnabled(undercalves)
end

word8 = "Disabled"
item8 = item_stack.createItem("minecraft:potion")
item8.setTag("{\"CustomPotionColor\":"..vectors.rgbToINT({1,0,0}).."}")
action_wheel.SLOT_8.setTitle("Whirlpool Effect "..word8)
action_wheel.SLOT_8.setItem(item8)
action_wheel.SLOT_8.setFunction(
function() 
	bubbles = not bubbles
	sound.playSound("minecraft:block.bubble_column.upwards_inside", {playerPos.x,playerPos.y,playerPos.z, 1, 1}) 
	if not bubbles then
		word8 = "Disabled"
		item8.setTag("{\"CustomPotionColor\":"..vectors.rgbToINT({1,0,0}).."}")
	else
		word8 = "Enabled"
		item8.setTag("{\"CustomPotionColor\":"..vectors.rgbToINT({0,1,0}).."}")
	end
	action_wheel.SLOT_8.setTitle("Whirlpool Effect "..word8)
	action_wheel.SLOT_8.setItem(item8)
	ping.whirlpool(bubbles)
end)

function pingwhirlpool(val)
	bubbles = val
end
--clothes table
--armor table and function
armor = {
headfuture = {model.base.Head.HelmetFuture},
head = { model.base.Head.Helmet, model.base.Body.neckchoker, },
chest = { model.base.Body.chest, model.base.Body.ChestArmorBelt, model.base.Body.clothes1, model.base.RightArm.armor, model.base.LeftArm.armor2, model.base.Body.bodyarmor, model.base.BodyDigitigrade.bodyarmorDigi.bodyarmorDigi},
elytra = { model.base.Body.RIGHT_ELYTRA, model.base.Body.LEFT_ELYTRA },
legs = {model.base.LeftLeg.leftlegarmor.leggings, model.base.Body.Leggings.Armor, model.base.Body.Leggings.ArmorTrim,
    model.base.LeftLeg.leftlegarmor.leggings2, model.base.RightLeg.rightlegarmor.leggings, model.base.RightLeg.rightlegarmor.leggings2, --GNamimates was here (sorry dint tell you that I added this XD)
    model.base.Body.tailonland.tailarmor, model.base.Body.LeggingsTop.LeggingsTop, model.base.Body.Leggings.Armor, model.base.Body.Leggings.ArmorTrim,
    model.base.Body.Leggings.bone.armor1, model.base.Body.Leggings.bone.Armor1, model.base.BodyDigitigrade.tailonland2.tailarmor,
    model.base.RightLeg.rightlegarmor.rightlegleggingslow.leggings2, model.base.RightLeg.rightlegarmor.rightlegleggingsupp.leggings}, --model.base.RightLeg.clothes2, model.base.LeftLeg.clothes3 },
boots = { model.base.LeftLeg.bootsleft.boots, model.base.RightLeg.bootsright.boots, model.base.Body.Boots }
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
model.base.Head.HelmetFuture.setEnabled(false)
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
        update_armor(armor.head, "setUV", {0/texture_width, 64/texture_height})
    elseif head == "minecraft:netherite_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 128/texture_height})
        update_armor(armor.headfuture, "setUV", {0/texture_width, 0/texture_height})
    elseif head == "minecraft:diamond_helmet" then
    update_armor(armor.head, "setUV", {0/texture_width, 96/texture_height})
    update_armor(armor.headfuture, "setUV", {0/texture_width, -16/texture_height})
    --mythic metals armor recognition for helmet/head starts here
    elseif head == "mythicmetals:adamantite_helmet" then
        update_armor (armor.head, "setUV", {112/texture_width, -32/texture_height})
    elseif head == "mythicmetals:aquarium_helmet" then
        update_armor (armor.head, "setUV", {112/texture_width, 0/texture_height})
    elseif head == "mythicmetals:banglum_helmet" then
        update_armor (armor.head, "setUV", {112/texture_width, 32/texture_height})
    elseif head == "mythicmetals:bronze_helmet" then
        update_armor(armor.head, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.head, "setColor", {168/255, 112/255, 30/255})
    elseif head == "mythicmetals:copper_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.head, "setColor", {250/255, 122/255, 100/255})
    elseif head == "mythicmetals:carmot_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.head, "setColor", {255/255, 70/255, 150/255})
    elseif head == "mythicmetals:celestium_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.head, "setColor", {255/255, 70/255, 150/255})
    elseif head == "mythicmetals:orichalcum_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.head, "setColor", {100/255, 140/255, 100/255})
    elseif head == "mythicmetals:palladium_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.head, "setColor", {240/255, 120/255, 40/255})
    elseif head == "mythicmetals:mythril_helmet" then
        update_armor(armor.head, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.head, "setColor", {80/255, 130/255, 255/255})
    elseif head == "mythicmetals:durasteel_helmet" then
        update_armor(armor.head, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.head, "setColor", {40/255, 40/255, 40/255})
    elseif head == "mythicmetals:silver_helmet" then
        update_armor(armor.head, "setUV", {224/texture_width, 32/texture_height})
        update_armor(armor.head, "setColor", {230/255, 230/255, 230/255})
    elseif head == "mythicmetals:midas_gold_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 64/texture_height})
        update_armor(armor.head, "setColor", {240/255, 203/255, 60/255})


    --mythic metals armor recognition for helmet/head ends here

    elseif head == "minecraft:iron_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 0/texture_height})
        --update_armor(armor.head, "setColor", {255/255,255/255,255/255})
        update_armor(armor.headfuture, "setUV", {0/texture_width, -48/texture_height})
    elseif head == "minecraft:golden_helmet" then
        update_armor(armor.head, "setUV", {0, 64/texture_height})
        update_armor(armor.headfuture, "setUV", {0/texture_width, -32/texture_height})
    elseif head == "minecraft:chainmail_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, 32/texture_height})
        update_armor(armor.headfuture, "setUV", {0/texture_width, -64/texture_height})
    elseif head == "minecraft:leather_helmet" then
        update_armor(armor.head, "setUV", {0/texture_width, -32/texture_height})
        if player.getEquipmentItem(6).getTag() ~= nil and player.getEquipmentItem(6).getTag().display ~= nil and player.getEquipmentItem(6).getTag().display.color ~= nil then
            update_armor(armor.head, "setColor", vectors.intToRGB(player.getEquipmentItem(6).getTag().display.color))
        else
            update_armor(armor.head, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --chest
    update_armor(armor.chest, "setColor", {1, 1, 1})
    if chest == "minecraft:air" or chest == "minecraft:elytra" then
        update_armor(armor.chest, "setEnabled", false)
    else
        update_armor(armor.chest, "setEnabled", true)
    end

    if player.getEquipmentItem(5).hasGlint() then
        update_armor(armor.chest, "setShader", "Glint")
        update_armor(armor.elytra, "setShader", "Glint")
    else
        update_armor(armor.chest, "setShader", "None")
        update_armor(armor.elytra, "setShader", "None")
    end


    if chest == "minecraft:netherite_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 128/texture_height})
    elseif chest == "minecraft:diamond_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 96/texture_height})
    --mythic metals armor recognition starts here
    elseif chest == "mythicmetals:adamantite_chestplate" then
        update_armor(armor.chest, "setUV", {112/texture_width, -32/texture_height})
    elseif chest == "mythicmetals:aquarium_chestplate" then
        update_armor(armor.chest, "setUV", {112/texture_width, 0/texture_height})
    elseif chest == "mythicmetals:banglum_chestplate" then
        update_armor (armor.chest, "setUV", {112/texture_width, 32/texture_height})
    elseif chest == "mythicmetals:bronze_chestplate" then
        update_armor(armor.chest, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.chest, "setColor", {168/255, 112/255, 30/255})
    elseif chest == "mythicmetals:copper_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.chest, "setColor", {250/255, 122/255, 100/255})
    elseif chest == "mythicmetals:carmot_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.chest, "setColor", {255/255, 70/255, 150/255})
    elseif chest == "mythicmetals:celestium_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.chest, "setColor", {255/255, 70/255, 150/255})
    elseif chest == "mythicmetals:orichalcum_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.chest, "setColor", {100/255, 140/255, 100/255})
    elseif chest == "mythicmetals:palladium_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.chest, "setColor", {240/255, 120/255, 40/255})
    elseif chest == "mythicmetals:mythril_chestplate" then
        update_armor(armor.chest, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.chest, "setColor", {80/255, 130/255, 255/255})
    elseif chest == "mythicmetals:durasteel_chestplate" then
        update_armor(armor.chest, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.chest, "setColor", {40/255, 40/255, 40/255})
    elseif chest == "mythicmetals:silver_chestplate" then
        update_armor(armor.chest, "setUV", {224/texture_width, 32/texture_height})
        update_armor(armor.chest, "setColor", {230/255, 230/255, 230/255})
    elseif chest == "mythicmetals:midas_gold_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 64/texture_height})
        update_armor(armor.chest, "setColor", {240/255, 203/255, 60/255})


    --mythic metals armor recognition for chest ends here

    elseif chest == "minecraft:iron_chestplate" then
        update_armor(armor.chest, "setUV", {0, 0})
    elseif chest == "minecraft:golden_chestplate" then
        update_armor(armor.chest, "setUV", {0, 64/texture_height})
    elseif chest == "minecraft:chainmail_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, 32/texture_height})
    elseif chest == "minecraft:leather_chestplate" then
        update_armor(armor.chest, "setUV", {0/texture_width, -32/texture_height})
        if player.getEquipmentItem(5).getTag() ~= nil and player.getEquipmentItem(5).getTag().display ~= nil and player.getEquipmentItem(5).getTag().display.color ~= nil then
            update_armor(armor.chest, "setColor", vectors.intToRGB(player.getEquipmentItem(5).getTag().display.color))
        else
            update_armor(armor.chest, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --legs
    update_armor(armor.legs, "setColor", {1, 1, 1})
    if legs == "minecraft:air" or legs == "minecraft:elytra" then
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
        update_armor(armor.legs, "setUV", {0/texture_width, 128/texture_height})
    elseif legs == "minecraft:diamond_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 96/texture_height})
        --mythic metals armor recognition starts here
    elseif legs == "mythicmetals:adamantite_leggings" then
        update_armor(armor.legs, "setUV", {112/texture_width, -32/texture_height})
    elseif legs == "mythicmetals:aquarium_leggings" then
        update_armor(armor.legs, "setUV", {112/texture_width, 0/texture_height})
    elseif legs == "mythicmetals:banglum_leggings" then
        update_armor (armor.legs, "setUV", {112/texture_width, 32/texture_height})
    elseif legs == "mythicmetals:bronze_leggings" then
        update_armor(armor.legs, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.legs, "setColor", {168/255, 112/255, 30/255})
    elseif legs == "mythicmetals:copper_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.legs, "setColor", {250/255, 122/255, 100/255})
    elseif legs == "mythicmetals:carmot_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.legs, "setColor", {255/255, 70/255, 150/255})
    elseif legs == "mythicmetals:celestium_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.legs, "setColor", {255/255, 70/255, 150/255})
    elseif legs == "mythicmetals:orichalcum_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.legs, "setColor", {100/255, 140/255, 100/255})
    elseif legs == "mythicmetals:palladium_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.legs, "setColor", {240/255, 120/255, 40/255})
    elseif legs == "mythicmetals:mythril_leggings" then
        update_armor(armor.legs, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.legs, "setColor", {80/255, 130/255, 255/255})
    elseif legs == "mythicmetals:durasteel_leggings" then
        update_armor(armor.legs, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.legs, "setColor", {40/255, 40/255, 40/255})
    elseif legs == "mythicmetals:silver_leggings" then
        update_armor(armor.legs, "setUV", {224/texture_width, 32/texture_height})
        update_armor(armor.legs, "setColor", {230/255, 230/255, 230/255})
    elseif legs == "mythicmetals:midas_gold_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 64/texture_height})
        update_armor(armor.legs, "setColor", {240/255, 203/255, 60/255})


    --mythic metals armor recognition for legs ends here

    elseif legs == "minecraft:iron_leggings" then
        update_armor(armor.legs, "setUV", {0, 0})
    elseif legs == "minecraft:golden_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 64/texture_height})
    elseif legs == "minecraft:chainmail_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, 32/texture_height})
    elseif legs == "minecraft:leather_leggings" then
        update_armor(armor.legs, "setUV", {0/texture_width, -32/texture_height})
        if player.getEquipmentItem(4).getTag() ~= nil and player.getEquipmentItem(4).getTag().display ~= nil and player.getEquipmentItem(4).getTag().display.color ~= nil then
            update_armor(armor.legs, "setColor", vectors.intToRGB(player.getEquipmentItem(4).getTag().display.color))
        else
            update_armor(armor.legs, "setColor", {134/255 , 82/255 , 53/255})
        end
    end

    --boots
    update_armor(armor.boots, "setColor", {1, 1, 1})
    if boots == "minecraft:air" or boots == "minecraft:elytra" then
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
        update_armor(armor.boots, "setUV", {0/texture_width, 128/texture_height})
    elseif boots == "minecraft:diamond_boots" then
        update_armor(armor.boots, "setUV", {0/texture_width, 96/texture_height})
    --mythic metals armor recognition starts here (boots/paws/feet [keywords])
    elseif boots == "mythicmetals:adamantite_boots" then
        update_armor(armor.boots, "setUV", {112/texture_width, -32/texture_height})
    elseif boots == "mythicmetals:aquarium_boots" then
        update_armor(armor.boots, "setUV", {112/texture_width, 0/texture_height})
    elseif boots == "mythicmetals:banglum_boots" then
        update_armor (armor.boots, "setUV", {112/texture_width, 32/texture_height})
    elseif boots == "mythicmetals:bronze_boots" then
        update_armor(armor.boots, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.boots, "setColor", {168/255, 112/255, 30/255})
    elseif boots == "mythicmetals:copper_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.boots, "setColor", {250/255, 122/255, 100/255})
    elseif boots == "mythicmetals:carmot_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.boots, "setColor", {255/255, 70/255, 150/255})
    elseif boots == "mythicmetals:celestium_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.boots, "setColor", {255/255, 70/255, 150/255})
    elseif boots == "mythicmetals:orichalcum_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width, -0/texture_height})
        update_armor(armor.boots, "setColor", {100/255, 140/255, 100/255})
    elseif boots == "mythicmetals:palladium_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width,-32/texture_height})
        update_armor(armor.boots, "setColor", {240/255, 120/255, 40/255})
    elseif boots == "mythicmetals:mythril_boots" then
        update_armor(armor.boots, "setUV", {336/texture_width, -32/texture_height})
        update_armor(armor.boots, "setColor", {80/255, 150/255, 255/255})
    elseif boots == "mythicmetals:durasteel_boots" then
        update_armor(armor.boots, "setUV", {224/texture_width, -32/texture_height})
        update_armor(armor.boots, "setColor", {40/255, 40/255, 40/255})
    elseif boots == "mythicmetals:silver_boots" then
        update_armor(armor.boots, "setUV", {224/texture_width, 32/texture_height})
        update_armor(armor.boots, "setColor", {230/255, 230/255, 230/255})
    elseif boots == "mythicmetals:midas_gold_boots" then
        update_armor(armor.boots, "setUV", {0/texture_width, 64/texture_height})
        update_armor(armor.boots, "setColor", {240/255, 203/255, 60/255})

    --mythic metals armor recognition ends here (boots/paws/feet [keywords])
    elseif boots == "minecraft:iron_boots" then

        update_armor(armor.boots, "setUV", {0, 0})
    elseif boots == "minecraft:golden_boots" then
        update_armor(armor.boots, "setUV", {0, 64/texture_height})
    elseif boots == "minecraft:chainmail_boots" then
        update_armor(armor.boots, "setUV", {0, 32/texture_height})
    elseif boots == "minecraft:leather_boots" then
        update_armor(armor.boots, "setUV", {0/texture_width, -32/texture_height})
        if player.getEquipmentItem(3).getTag() ~= nil and player.getEquipmentItem(3).getTag().display ~= nil and player.getEquipmentItem(3).getTag().display.color ~= nil then
            update_armor(armor.boots, "setColor", vectors.intToRGB(player.getEquipmentItem(3).getTag().display.color))
        else
            update_armor(armor.boots, "setColor", {134/255 , 82/255 , 53/255})
        end
    end
end


--function ping.clothestoggle(x)
 --   model.base.RightLeg.clothes2.setEnabled(x)
 --   model.base.LeftLeg.clothes3.setEnabled(x)
 --   model.base.Body.clothes1.setEnabled(x)
--end
--action_wheel.SLOT_1.setItem("minecraft:stick")
--action_wheel.SLOT_1.setFunction(function() toggle = not toggle ping.clothestoggle(toggle) end)



--TAIL ANIMATION TEST
pos = nil
_pos = nil
velocity = nil

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
end

rot_1 = 0
long = 0
sped = 0

function render(delta)
    if player.getAnimation() == "SWIMMING" then---diferent movements and positions for tail
  
      rot_1 = rot_1 + (70 - rot_1) * 0.07
  
      long = long + (2 - long) * 0.2
    elseif player.getAnimation() == "FALL_FLYING" then
    
  
      rot_1 = rot_1 + (70 - rot_1) * 0.07
  
      long = long + (0 - long) * 0.2
    elseif player.isSneaky() then
  
      rot_1 = rot_1 + (20 - rot_1) * 0.07
  
      long = long + (7 - long) * 0.2
    elseif player.getAnimation() == "STANDING" then
  
      rot_1 = rot_1 + (50 - rot_1) * 0.07
  
      long = long + (2 - long) * 0.2
    end
    if math.abs(velocity.x) > 0.15 then
      sped = sped + (0.5 - sped) * 0.1
    elseif math.abs(velocity.z) > 0.15 then
       sped = sped + (0.5 - sped) * 0.1
    else
      sped = sped + (0 - sped) * 0.1
    end
  
    wag = long * math.sin((world.getTime()+delta )* 0.3)
    wager = sped * 30 * math.sin((world.getTime()+delta )* 0.6)
  
    model.base.BodyDigitigrade.tailonland2.setRot({rot_1 + wag + -sped * 40 + velocity.y*20,wager,0})
    model.base.BodyDigitigrade.tailonland2.bone4.setRot({-rot_1/2 + wag,wager,0})
  end

-- Tail Glow Animation Test
frames4 = {
    {0,0},     -- closed torso eye
    {1/texture_width,0}, -- half closed eye
    {2/texture_width,0}, -- half closed eye w. emissive
    {3/texture_width,0}, -- wide open w. emissive
    {4/texture_width,0}, -- wide open w. emissive frame 2
    {5/texture_width,0}, -- half closed w. emissive
    {6/texture_width,0}, -- half closed eye
    {7/texture_width,0}, -- closed torso eye
}

time4 = 1
nextBlink4 = 0

--function tick()
    local time = world.getTime()
    model.base.Body.tailonland.bone3.tip.setUV({time % 8/texture_width,0/texture_width})
--end

function tick()
    if time4 > 8 then
        time4 = 1
        nextBlink4 = world.getTime() + math.random(15,250)
    end
    model.base.Body.tailonland.bone3.tip.setUV(frames4[time4])
    if nextBlink4 < world.getTime() then
        time4 = time4 + 1
    end
end



--MERMAID TAIL AND LEG REPLACEMENT SCRIPT TEST 1

-- Original code belongs to Detrilogue
-- Huge thanks to JGTB0PL for their work on the animations!
-- Code has been massively edited by TotalTakeover, as well as custom armor made by TotalTakeover

--	Info: Tail color
tailcolor = colors.white
model.base.Body.Tail.setColor(tailcolor)
model.base.Body.Tail1.setColor(tailcolor)

-- Info: Default color: {25/255,175/255,240/255}

for key, value in pairs(vanilla_model) do
	value.setEnabled(false)
end


-- 	Info:
--	Due to Figura updates, textures toggle differently from this models creation.
--	As a fast means of fixing this, remove the "--" from the fins to re-enable the emission of specific fins.
--	-Total :)
function ping.emissions(val)
	emissive = val
	model.base.Body.Tail1.BackEm.setEnabled(emissive)
	model.base.Body.Tail1.RightEm.setEnabled(emissive)
	model.base.Body.Tail1.LeftEm.setEnabled(emissive)
	model.base.Body.Tail1.Tail2.Tail3.Tail4.TailEm.setEnabled(emissive)
end

enable_tail = false
lastSpeed = 0
speed = 0
bubbles = false
EnchLegins = false
EnchBoots = false
block= {}
block['name']='minecraft:air'
player_state = "STANDING"
timer = 10
health = 20
lastHealth = 0
dead = false

function reset_angles(part)
    part.setRot({})
end
function healthcheck(health)
	if (health == 0 and not dead) then
		sound.playSound('entity.salmon.death',{playerPos.x,playerPos.y,playerPos.z,1,1})
		dead = true
	else
		if health < lastHealth then
			sound.playSound('entity.salmon.hurt',{playerPos.x,playerPos.y,playerPos.z,1,1})
		else
			if health == player.getMaxHealth() then
				dead = false
			end
		end
	end
	lastHealth = health
end


-- Info: Enables or disables the tail and the legs
function switchTail(enable_tail)
    --model.base.Body.setEnabled(not(enable_tail) and armored)
	model.base.LeftLeg.leftlegarmor.setEnabled(not(enable_tail) and armored)
	model.base.RightLeg.rightlegarmor.setEnabled(not(enable_tail) and armored)
    model.base.Body.tailonland.setEnabled(not(enable_tail) and armored)
    --model.base.RightLeg.bootsright.boots.setEnabled(not(enable_tail) and armored)
    --model.base.LeftLeg.bootsleft.boots.setEnabled(not(enable_tail) and armored)
    --model.base.RightLeg.bootsright.boots.setEnabled(not(enable_tail) and armored)
    --model.base.LeftLeg.bootsleft.boots.setEnabled(not(enable_tail) and armored)
    model.base.RightLeg.bootsright.setEnabled(not(enable_tail) and armored)
    model.base.LeftLeg.bootsleft.setEnabled(not(enable_tail) and armored)
    model.base.BodyDigitigrade.bodyarmorDigi.setEnabled(not(enable_tail) and armored)
    --model.base.Body.Boots.bone1.bone2.Boots.setEnabled(not(enable_tail) and armored)
	
	model.base.LeftLeg.setEnabled(not(enable_tail))
--    model.base.LeftLeg.DigitigradeLeg2.setEnabled(not(enable_tail))
	model.base.RightLeg.setEnabled(not(enable_tail))
    model.base.Body.tailonland.setEnabled(not(enable_tail))
    model.base.Head.ThreeDHat.CatLeftEar.setEnabled(not(enable_tail))
	model.base.Head.ThreeDHat.CatRightEar.setEnabled(not(enable_tail))
--    model.base.BodyMermaid.setEnabled(enable_tail)
	model.base.Body.LeggingsTop.setEnabled(enable_tail and armored)
	model.base.Body.Leggings.setEnabled(enable_tail and armored)
	model.base.Body.Boots.bone1.bone2.LeatherBoots.setEnabled(enable_tail and armored)
	model.base.Body.Boots.bone1.bone2.Boots.setEnabled(enable_tail and armored)
    model.base.Body.bodyarmor.setEnabled(enable_tail and armored)
    --model.base.Body.bodyarmor.setEnabled(enable_tail and armored)
    --model.base.LeftLeg.bootsleft.boots.setEnabled(enable_tail and armored)
    --model.base.RightLeg.bootsright.boots.setEnabled(enable_tail and armored)
	
    model.base.BodyDigitigrade.setEnabled(not(enable_tail))
    model.base.Body.setEnabled(enable_tail)
	model.base.Body.Tail.setEnabled(enable_tail)
	model.base.Body.Tail1.setEnabled(enable_tail)
    model.base.Head.LeftEar.setEnabled(enable_tail)
    model.base.Head.RightEar.setEnabled(enable_tail)
    model.base.Body.LeftBackFin.setEnabled(enable_tail)
    model.base.Body.RightBackFin.setEnabled(enable_tail)
end

-- Info: Toggles the tail
tOn= 0
tOff = 0
function tick()
    if health ~= 0 then
		playerPos = player.getPos()
    end
    local checkPos = {playerPos.x, playerPos.y+0.15, playerPos.z}
    if world.getBlockState(checkPos) ~= nil then
		pos_block = world.getBlockState(checkPos)
    end
    if player.isTouchingWater() then
        tOff = 0
        tOn = tOn + 1
        if tOn >= 20 then
            switchTail(true)
        end
    else
        tOn = 0
        tOff = tOff + 1
        if tOff >= 20 then
            switchTail(false)
        end
    end
end

    --if player.isTouchingWater() == true then
          --enable_tail = true
          --switchTail(enable_tail)
      --elseif not player.isTouchingWater() then
          --enable_tail = false
          --switchTail(enable_tail)
        --end
    --end


-- Info: Toggles head fins when raining
tHeadOn = 0
tHeadOff = 0
--function tick()
--    if player.isInRain() then
--        tHeadOff = 0
--        tHeadOn = tHeadOn + 1
--        if tHeadOn >= 20 then     
--            model.base.Head.LeftEar.setEnabled(true)
--            model.base.Head.RightEar.setEnabled(true)
--            model.base.Head.ThreeDHat.CatLeftEar.setEnabled(false)
--            model.base.Head.ThreeDHat.CatRightEar.setEnabled(false)
--        end
--    else
--        tHeadOn = 0
--        tHeadOff = tHeadOff + 1
--        if tHeadOff >= 20 then
--            model.base.Head.LeftEar.setEnabled(false)
--            model.base.Head.RightEar.setEnabled(false)
--            model.base.Head.ThreeDHat.CatLeftEar.setEnabled(true)
--            model.base.Head.ThreeDHat.CatRightEar.setEnabled(true)
--        end
--    end
--end

function tick()
    if player.isInRain() then
--        tHeadOff = 0
--        tHeadOn = tHeadOn + 1
--        if tHeadOn >= 20 then     
            model.base.Head.LeftEar.setEnabled(true)
            model.base.Head.RightEar.setEnabled(true)
            model.base.Head.ThreeDHat.CatLeftEar.setEnabled(false)
            model.base.Head.ThreeDHat.CatRightEar.setEnabled(false)
    end
end




-- Info: Animates the tail

function animateTail(vala)
	model.base.Body.setRot({ math.sin(vala) * 3, 0, 0 })
	armor_model.CHESTPLATE.setRot({ -math.sin(vala) * 0.04, 0, 0 })
	
	model.base.Head.LeftEar.setRot({ -22.5, -math.sin(vala)*2-20, 0 })
	model.base.Head.RightEar.setRot({ -22.5, math.sin(vala)*2+20, 0 })
    model.base.Body.LeftBackFin.setRot({  -5, -math.sin(-vala)*2-20,0})
    model.base.Body.RightBackFin.setRot({ -5, math.sin(-vala)*2+20,0})
	
	
	model.base.Body.Tail1.setRot({  math.sin(vala -1) * 7, 0, 0 })
	model.base.Body.Leggings.setRot({ math.sin(vala -1) * 7, 0, 0 })
	model.base.Body.Boots.setRot({ math.sin(vala -1) * 7, 0, 0 })
	model.base.Body.LeggingsTop.LeggingsTopTrimFront.setRot({ math.sin(vala -1) * 4, 0, 0 })
	model.base.Body.LeggingsTop.LeggingsTopTrimBack.setRot({ math.sin(vala -1) * 4, 0, 0 })
	
	model.base.Body.Tail1.Tail2.setRot({ math.sin(vala -2) * 8, 0, 0 })
	model.base.Body.Leggings.bone.setRot({ math.sin(vala -2) * 8, 0, 0 })
	model.base.Body.Boots.bone1.setRot({ math.sin(vala -2) * 8, 0, 0 })
--    model.base.Body.Leggings.setRot({ math.sin(vala -2) * 8, 0, 0 })
	
    model.base.Body.Tail1.Tail2.Tail3.setRot({ math.sin(vala -3) * 12, 0, 0 })
	model.base.Body.Boots.bone1.bone2.setRot({ math.sin(vala -3) * 12, 0, 0 })	

    model.base.Body.Tail1.Tail2.Tail3.Tail4.setRot({ math.sin(vala -4) * 15, 0, 0 })	
end

function abilitycheck()
	nbt = player.getNbtValue("cardinal_components.apoli:powers.Powers")
	if nbt ~= nil then
		for i, v in pairs(nbt) do
			if v["type"] == "origins:water_vision" then
				if v["data"] == 1 then
					--model.Player.HEAD.Eyes.setEnabled(true)
				else
					--model.Player.HEAD.Eyes.setEnabled(false)
				end
				break
			end
		end
	end
end



--isInWater() function

liquidBlocks = {
    "minecraft:water",
    "minecraft:kelp" ,
    "minecraft:kelp_plant",
    "minecraft:tall_seagrass",
    "minecraft:lava",
}

function isInWater()
	if health ~= 0 then
		playerPos = player.getPos()
	end
	local checkPos = {playerPos.x, playerPos.y+0.15, playerPos.z}
	if world.getBlockState(checkPos) ~= nil then
		pos_block = world.getBlockState(checkPos)
	end
    if pos_block ~= nil 
	and pos_block.properties ~= nil
    and pos_block.properties.waterlogged == "true" then
        waterlogged = true
    else
        waterlogged = false
    end    
    if pos_block ~= nil then
        local WFound = false
        for key, value in pairs(liquidBlocks) do
            if key == pos_block.name then
                enable_tail = true
                timer = 10
                break
            end
        end
        
    else
        if timer > 0 then
            enable_tail = false
            timer = timer - 1
        end
    end
	--switchTail(enable_tail)
end
-- Info: Sets the speed for the tail animation
ticker = 0
function tick()
	ticker = ticker + 1
    --animateTail()
	isInWater()
	--local velocity = playerPos - lastpos
	lastpos = playerPos
	local playerState = player.getAnimation()
	healthcheck(player.getHealth())
	--abilitycheck()
	if enable_tail then
		--armor()
		lastSpeed = speed
		playerspeed = math.sqrt( velocity.x^2 + velocity.y^2 + velocity.z^2 )
		speed = speed + (playerspeed*5+0.75)
		if playerState == "SWIMMING" and bubbles then
			model.base.Particles.Group1.setRot({0,ticker*10,0})
			model.base.Particles.Group2.setRot({0,ticker*10-60,0})
			model.base.Particles.Group3.setRot({0,ticker*10-120,0})
			particle.addParticle("bubble",{model.base.Particles.Group1.partToWorldPos({10,3,0}),0,0,0})
			particle.addParticle("bubble",{model.base.Particles.Group2.partToWorldPos({10,3,0}),0,0,0})
			particle.addParticle("bubble",{model.base.Particles.Group3.partToWorldPos({10,3,0}),0,0,0})
			particle.addParticle("bubble",{model.base.Particles.Group1.partToWorldPos({-10,3,0}),0,0,0})
			particle.addParticle("bubble",{model.base.Particles.Group2.partToWorldPos({-10,3,0}),0,0,0})
			particle.addParticle("bubble",{model.base.Particles.Group3.partToWorldPos({-10,3,0}),0,0,0})
		end
	end
end
function render(delta)
	if (enable_tail) then
		animateTail((math.lerp(lastSpeed,speed,delta) * 0.2))
    else
		model.base.Head.LeftEar.setRot({ -22.5, -20, 0 })
		model.base.Head.RightEar.setRot({ -22.5, 20, 0 })
        model.base.Body.LeftBackFin.setRot({ -22.5, -20,0})
        model.base.Body.RightBackFin.setRot({ -22.5, 20,0})
		reset_angles(model.base.Body)
	end
end

--	Info:
--	Each armor texture (if placed correctly) has a Y-Offset of 19
--	Adding armor textures needs proper UV placement
--	setUV is based on origin position of x 64 y 0, starting with Leather Armor
armorType = {}
armorType['leather']	= { 0/128 , 0/texture_width }
armorType['iron']		= { 0/128 , 19/texture_width}
armorType['chainmail']	= { 0/128 , 38/texture_width}
armorType['golden']		= { 0/128 , 57/texture_width}
armorType['diamond']	= { 0/128 , 76/texture_width}
armorType['netherite']	= { 0/128 , 95/texture_width}


--function tick()
--    if vanilla_model.TORSO.getOriginRot()[1] == 0.5 then
--        vanilla_model.y_offset


--function tick()
--    if player.getAnimation() == "CROUCHING" then
--        model.base.BodyDigitigrade.setRot({0,0,0})
--    else
--        model.base.BodyDigitigrade.setRot({0,0,0})
--    end
--end



do
    action_wheel_pages = {}

    local location = nil
    local page = 1

    local toggle_ping_id = 0

    local function renderSlot(slot, element)
        slot.setTitle(element.title)
        slot.setItem(element.item)
        slot.setHoverItem(element.hoverItem)
        slot.setColor(element.color)
        slot.setHoverColor(element.hoverColor)
        slot.setFunction(element.func) -- can be nil for folders
    end

    local function update()
        if location == nil then return end

        local requireMultiplePages = (#location.contents > 8) or (location.back~=nil)
        local pageSize = 8

        if requireMultiplePages then
            pageSize = 6

            action_wheel.SLOT_4.setFunction(function ()
                page = page + 1
                if page > math.ceil(#location.contents/6) then
                    page = math.ceil(#location.contents/6)
                end
                if #location.contents == 0 then
                    page = 1
                end
                update()
            end)
            action_wheel.SLOT_5.setFunction(function ()
                page = page - 1
                if page < 1 then
                    page = 1
                end
                update()
            end)
    
            if page == math.ceil(#location.contents/6) or #location.contents == 0 then
                action_wheel.SLOT_4.setItem("minecraft:air")
                action_wheel.SLOT_4.setTitle("")
            else
                action_wheel.SLOT_4.setItem("minecraft:arrow")
                action_wheel.SLOT_4.setTitle("Next")
            end
            
            if page == 1 then
                if location.back == nil then
                    action_wheel.SLOT_5.setItem("minecraft:air")
                    action_wheel.SLOT_5.setTitle("")
                else
                    action_wheel.SLOT_5.setItem("minecraft:dark_oak_door")
                    action_wheel.SLOT_5.setTitle("Exit")
                    action_wheel.SLOT_5.setFunction(function ()
                        location = location.back
                        page = 1
                        update()
                    end)
                end
            else
                action_wheel.SLOT_5.setItem("minecraft:arrow")
                action_wheel.SLOT_5.setTitle("Previous")
            end
        end

        local slotid = 1
        for i = page*pageSize-(pageSize-1), page*pageSize, 1 do
            if i <= #location.contents then
                renderSlot(action_wheel["SLOT_"..slotid], location.contents[i])
                if location.contents[i].type == "folder" then
                    action_wheel["SLOT_"..slotid].setFunction(function ()
                        location = location.contents[i]
                        page = 1
                        update()
                    end)
                end
            else
                renderSlot(action_wheel["SLOT_"..slotid], {})
            end
            slotid = slotid + 1
            if slotid == 4 and requireMultiplePages then slotid = slotid + 2 end
            if slotid > 8 then slotid = 1 end
        end
    end

    function action_wheel_pages.createFolder(title, item)
        local ret = {
            type = "folder",
            contents = {},
            back = nil,

            title = title,
            item = item,
            hoverItem = nil,
            color = nil,
            hoverColor = nil
        }
        ret.add = function (element)
            if element.type == "folder" then
                element.back = ret
            end
            table.insert(ret.contents, element)
        end
        ret.remove = function (element)
            for k,v in pairs(ret.contents) do
                if v == element then
                    ret.contents[k] = nil
                end
            end
        end
        ret.setTitle = function (title)
            ret.title = title
        end
        ret.getTitle = function ()
            return ret.title
        end
        ret.setItem = function (item)
            ret.item = item
        end
        ret.getItem = function ()
            return ret.item
        end
        ret.setHoverItem = function (hoverItem)
            ret.hoverItem = hoverItem
        end
        ret.getHoverItem = function ()
            return ret.hoverItem
        end
        ret.setColor = function (color)
            ret.color = color
        end
        ret.getColor = function ()
            return ret.color
        end
        ret.setHoverColor = function (color)
            ret.hoverColor = color
        end
        ret.getHoverColor = function ()
            return ret.hoverColor
        end
        ret.clear = function ()
            ret = {
                type = "folder",
                contents = {},
                back = nil,
    
                title = nil,
                item = nil,
                hoverItem = nil,
                color = nil,
                hoverColor = nil
            }
        end
        return ret
    end
    
    function action_wheel_pages.createItem(title, item)
        local ret = {
            type = "item",
            func = nil,

            title = title,
            item = item,
            hoverItem = nil,
            color = nil,
            hoverColor = nil
        }
        ret.setFunction = function (func)
            ret.func = func
        end
        ret.getFunction = function (func)
            ret.func = func
        end
        ret.setTitle = function (title)
            ret.title = title
        end
        ret.getTitle = function ()
            return ret.title
        end
        ret.setItem = function (item)
            ret.item = item
        end
        ret.getItem = function ()
            return ret.item
        end
        ret.setHoverItem = function (hoverItem)
            ret.hoverItem = hoverItem
        end
        ret.getHoverItem = function ()
            return ret.hoverItem
        end
        ret.setColor = function (color)
            ret.color = color
        end
        ret.getColor = function ()
            return ret.color
        end
        ret.setHoverColor = function (color)
            ret.hoverColor = color
        end
        ret.getHoverColor = function ()
            return ret.hoverColor
        end
        ret.clear = function ()
            ret = {
                type = "item",
                func = nil,
    
                title = nil,
                item = nil,
                hoverItem = nil,
                color = nil,
                hoverColor = nil
            }
        end
        ret.toggleVar = function (variable, on_text, on_icon, off_text, off_icon)
            local _toggle_ping_id = toggle_ping_id
            network.registerPing("action_wheel_toggleVar_ping_".._toggle_ping_id)
            ret.setFunction(function () network.ping("action_wheel_toggleVar_ping_".._toggle_ping_id, not _G[variable]) end)
            _G["action_wheel_toggleVar_ping_".._toggle_ping_id] = function(x)
                _G[variable] = x
                if _G[variable] then
                    ret.setTitle(off_text) 
                    ret.setItem(off_icon)
                else
                    ret.setTitle(on_text)
                    ret.setItem(on_icon)
                end
                update()
            end
            _G["action_wheel_toggleVar_ping_".._toggle_ping_id](_G[variable])
            toggle_ping_id = toggle_ping_id + 1
        end
        return ret
    end
    
    function action_wheel_pages.setLocation(folder)
        location = folder
        update()
    end
end
root = action_wheel_pages.createFolder("root", nil) -- root folder, everything goes inside that

chest = action_wheel_pages.createFolder("Folder","minecraft:chest") -- subfolder
ender_chest = action_wheel_pages.createFolder("Ender Folder","minecraft:ender_chest") -- another subfolder
apparel = action_wheel_pages.createFolder("Clothing Customization","minecraft:leather_chestplate")
underarmcustomis = action_wheel_pages.createFolder("Underarmour Customization", "minecraft:white_wool")
emotes = action_wheel_pages.createFolder("Emotes","minecraft:jukebox")
armorcustomis = action_wheel_pages.createFolder("Armour Customization", "minecraft:diamond_chestplate")

--root.add(chest) -- add folders to root
root.add(apparel)
--root.add(ender_chest)
root.add(armorcustomis)
root.add(emotes)
apparel.add(underarmcustomis)
action_wheel_pages.setLocation(root) -- you have to call this one time to set the root folder AFTER YOU ADDED ITEMS TO IT

is_sitting_down = false
LastuppedLeg = {false,false}
uppedLeg = {false,false}
sitdown = action_wheel_pages.createItem("Toggle Sit","oak_stairs")
sitdown.setFunction(function ()
    ping.toggleSitDown(not is_sitting_down)
end)

--SITTING CODE \/
animation.sitL.setBlendTime(0.2)
animation.sitR.setBlendTime(0.2)

ping.toggleSitDown = function (toggle)
    is_sitting_down = toggle
    if is_sitting_down then
        animation.sit.play()
    else
        animation.sit.stop()
        animation.sitL.stop()
        animation.sitR.stop()
        uppedLeg = {false,false}
    end
end
emotes.add(sitdown)

function tick()
    if is_sitting_down then
        LastuppedLeg = {uppedLeg[1],uppedLeg[2]}
        local rotationOffset = 0
        
        rotationOffset = -25
        local result = player.getPos()-vectors.of{-math.sin(math.rad(player.getBodyYaw()+rotationOffset)),0,math.cos(math.rad(player.getBodyYaw()+rotationOffset))}*-0.5
        uppedLeg[1] = (renderer.raycastBlocks(result, result+vectors.of{0,-0.3,0}, "COLLIDER","NONE") ~= nil)
        
        rotationOffset = 25
        result = player.getPos()-vectors.of{-math.sin(math.rad(player.getBodyYaw()+rotationOffset)),0,math.cos(math.rad(player.getBodyYaw()+rotationOffset))}*-0.5
        uppedLeg[2] = (renderer.raycastBlocks(result, result+vectors.of{0,-0.3,0}, "COLLIDER","NONE") ~= nil)
        if uppedLeg[1] ~= LastuppedLeg[1] then
            if uppedLeg[1] then
                animation.sitL.play()
            else
                animation.sitL.stop()
            end
        end
        if uppedLeg[2] ~= LastuppedLeg[2] then
            if uppedLeg[2] then
                animation.sitR.play()
            else
                animation.sitR.stop()
            end
        end
    end
end
--SITTING CODE /\

--function tick()
--    if player.isSneaky() then
--        animation.SNEAKING.play()
--    else
--        animation.SNEAKING.stop()
--    end
--end
chest.add(action_wheel_pages.createItem("Diamond","minecraft:diamond")) -- add inline item
coal = action_wheel_pages.createItem("Coal","minecraft:coal") -- create item
chest.add(coal) -- add item
chest.remove(coal) -- remove item

-- setFunction example
bread = action_wheel_pages.createItem("bread", "minecraft:bread")
bread.setFunction(function ()
    log("BREAD!")
end)
ender_chest.add(bread)

greenclothes = action_wheel_pages.createItem("Green", "minecraft:green_wool")
greenclothes.setFunction(function () ping.Clothes("green") end)
whiteclothes = action_wheel_pages.createItem("White", "minecraft:white_wool")
whiteclothes.setFunction(function () ping.Clothes("white") end)
blackclothes = action_wheel_pages.createItem("Black", "minecraft:black_wool")
blackclothes.setFunction(function () ping.Clothes("black") end)
redclothes = action_wheel_pages.createItem("Red", "minecraft:red_wool")
redclothes.setFunction(function () ping.Clothes("red") end)
blueclothes = action_wheel_pages.createItem("Blue", "minecraft:blue_wool")
blueclothes.setFunction(function () ping.Clothes("blue") end)
undertogglemain = action_wheel_pages.createItem("Underarmour "..word2, item2)
undertogglemain.setFunction(function()
        --sound.playSound("minecraft:item.armor.equip_generic", {playerPos.x,playerPos.y,playerPos.z, 0.75, 1}) 
        underarmored = not underarmored
        if not underarmored then
            word2 = "Invisible"
            item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
        else
            word2 = "Visible"
            item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
        end
        action_wheel.SLOT_1.setTitle("Underarmour "..word2)
        action_wheel.SLOT_1.setItem(item2)
        ping.underarmorSwitch(underarmored)
    end)
undercalvesmain = action_wheel_pages.createItem("Undercalves "..word3, item3)
undercalvesmain.setFunction(function()
	--sound.playSound("minecraft:item.armor.equip_generic", {playerPos.x,playerPos.y,playerPos.z, 0.75, 1}) 
	undercalves = not undercalves
	if not undercalves then
		word3 = "Invisible"
		item3.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
	else
		word3 = "Visible"
		item3.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
	end
	action_wheel.SLOT_1.setTitle("Undercalves "..word3)
	action_wheel.SLOT_1.setItem(item3)
	ping.undercalvesSwitch(undercalves)
end)


underarmcustomis.add(undertogglemain)
underarmcustomis.add(greenclothes)
underarmcustomis.add(whiteclothes)
underarmcustomis.add(redclothes)
underarmcustomis.add(blackclothes)
underarmcustomis.add(blueclothes)
underarmcustomis.add(undercalvesmain)
greencalves = action_wheel_pages.createItem("Green", "minecraft:green_wool")
greencalves.setFunction(ping.CalvesGreen)
bluecalves = action_wheel_pages.createItem("Blue", "minecraft:blue_wool")
bluecalves.setFunction(ping.CalvesBlue)
redcalves = action_wheel_pages.createItem("Red", "minecraft:red_wool")
redcalves.setFunction(ping.CalvesRed)
blackcalves = action_wheel_pages.createItem("Black", "minecraft:black_wool")
blackcalves.setFunction(ping.CalvesBlack)
whitecalves = action_wheel_pages.createItem("White", "minecraft:white_wool")
whitecalves.setFunction(ping.CalvesWhite)

underarmcustomis.add(greencalves)
underarmcustomis.add(whitecalves)
underarmcustomis.add(redcalves)
underarmcustomis.add(blackcalves)
underarmcustomis.add(bluecalves)


--ARMOUR CUSTOMIZATION PART START
ping.armorSwitch = function(vale)
	armored = vale
    model.base.Head.Helmet.HelmetCrown.setEnabled(armored)
    model.base.Body.bodyarmor.setEnabled(armored)
    model.base.BodyDigitigrade.bodyarmorDigi.bodyarmorDigi.setEnabled(armored)
--    model.base.Body.chest.ChestArmorBelt.setEnabled(armored)
--    model.base.Body.chest.cube.setEnabled(armored)
    --model.base.LeftArm.armor2.setEnabled(armored)
    model.base.RightArm.armor.chest.setEnabled(armored)
    model.base.RightArm.armor.chest2.setEnabled(armored)
    model.base.RightLeg.rightlegarmor.rightlegleggingsupp.leggings.setEnabled(armored)
    model.base.RightLeg.rightlegarmor.rightlegleggingslow.leggings2.setEnabled(armored)
    model.base.RightLeg.rightlegarmor.rightlegleggingslow.leggings2.setEnabled(armored)
    model.base.RightLeg.rightlegarmor.rightlegleggingsupp.leggings.setEnabled(armored)
    model.base.LeftLeg.leftlegarmor.leggings.setEnabled(armored)
    model.base.LeftLeg.leftlegarmor.leggings2.setEnabled(armored)
    model.base.LeftLeg.bootsleft.boots.setEnabled(armored)
    model.base.RightLeg.bootsright.boots.setEnabled(armored)
--	armor_model.HELMET.setEnabled(armored)
--	armor_model.HEAD_ITEM.setEnabled(armored)
--	armor_model.CHESTPLATE.setEnabled(armored)
end



armortogglemain = action_wheel_pages.createItem("Armour "..word2, item2)
armortogglemain.setFunction(function()
    armored = not armored
    if not armored then
        word2 = "Invisible"
        item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({1,0,0}).."}}")
    else
        word2 = "Visible"
        item2.setTag("{\"display\":{\"color\":"..vectors.rgbToINT({0,1,0}).."}}")
    end
    action_wheel.SLOT_1.setTitle("Armour "..word2)
    action_wheel.SLOT_1.setItem(item2)
    ping.armorSwitch(armored)
end)

armorcustomis.add(armortogglemain)
--ARMOUR CUSTOMIZATION PART END

--ARMOUR FUTURE START

is_feature_enabled = false
wordfuture = "OUI"
itemfuture = "minecraft:blaze_rod"
armorfeaturetoggle = action_wheel_pages.createItem("Future "..wordfuture, "minecraft:stick")
armorcustomis.add(armorfeaturetoggle)


function ping.futuredetectiontest(toggle)
    local has_something_on_head = player.getEquipmentItem(6).getType() ~= "minecraft:air"
    local wordfuture = "On"
    is_feature_enabled = toggle
    if is_feature_enabled then --and armor_model.HELMET == true then
        action_wheel.SLOT_2.setItem("minecraft:blaze_rod")
        
        --model.base.Head.Helmet.setEnabled(false)
        model.base.Head.Helmet.HelmetCrown.setEnabled(false)
        model.base.Head.HelmetFuture.setEnabled(has_something_on_head)
    --end
    else
        --model.base.Head.Helmet.setEnabled(false)
        --model.base.Head.HelmetFuture.setEnabled(true)
    --else if head == "minecraft:air" then
        wordfuture = "Off"
        action_wheel.SLOT_2.setItem("minecraft:stick")
        model.base.Head.HelmetFuture.setEnabled(false)
        model.base.Head.Helmet.HelmetCrown.setEnabled(true)
    --end
    end
    action_wheel.SLOT_2.setTitle("Future "..wordfuture)
end


armorfeaturetoggle.setFunction(function ()
    ping.futuredetectiontest(not is_feature_enabled)
end)
--futured = false
--wordfuture = "ON"
--armorfuturetoggle = action_wheel_pages.createItem("Future ", "minecraft:redstone_block")
--armorfuturetoggle.setFunction(function()
    --futval = not futval
    --ping.futureSwitch(futval)
--end)

--armorcustomis.add(armorfuturetoggle)

--futurearmored = false
--futval = false

--ping.futureSwitch = function (futval)
--    futval = not futval
--    futurearmored = not futurearmored
--    if futurearmored then
--        model.base.Head.HelmetFuture.setEnabled(futurearmored)
--        model.base.Head.Helmet.setEnabled(not(futurearmored))
--    else
--        model.base.Head.HelmetFuture.setEnabled(not(futurearmored))
--        model.base.Head.Helmet.setEnabled(futurearmored)
--    end
    --futval = not futval
--end


--model.base.Head.HelmetFuture.setEnabled(futurearmored)
