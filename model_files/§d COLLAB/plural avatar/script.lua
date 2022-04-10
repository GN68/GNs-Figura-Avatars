for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end

vanilla_model.CAPE.setEnabled(true)
armor_model.HEAD_ITEM.setEnabled(true)

UI = {
    ["class_481"] = "Creative Inventory",
    ["class_5289"] = "Gamemode Switcher",
    ["class_457"] = "Advancements",
    ["Do you want to open this link or copy it to your clipboard?"] = "Link Confirmation",
    ["class_473"] = "Edit Book",
    ["class_3935"] = "View Lectern",
    ["class_3872"] = "View Book",
    ["Unknown GUI"] = "Unknown",
    ["Game Menu"] = "Game Menu",
    ["Figura Menu"] = "Figura Menu",
}

Plurals = {
    {
        --'{"text":"Taylor", "color": "#FFA500"}'
        nameplate="taylor isnt done yet lmao",
        prefixes={"&"},
        modelRoot=model.MemberBlurry,
        eyes=model.MemberBlurry.Torso1.Head1.Eyes1,
        torso=model.MemberBlurry.Torso1
    },
    {
        nameplate='{"text":"Leah", "color": "#40E0D0"}',
        prefixes={"="},
        modelRoot=model.MemberLeah,
        eyes=model.MemberLeah.Torso2.Head2.Eyes2,
        torso=model.MemberLeah.Torso2
    },
    {
        nameplate='{"text":"Luke", "color": "#7DF1C7"}',
        prefixes={"]",".,",",."},
        modelRoot=model.MemberLuke,
        eyes=model.MemberLuke.Torso3.Head3.Eyes3,
        torso=model.MemberLuke.Torso3
    },
    {
        nameplate='{"text":"Seha", "color": "#FEA6CD"}',
        prefixes={","},
        modelRoot=model.MemberSeha,
        eyes=model.MemberSeha.Torso4.Head4.Eyes4,
        torso=model.MemberSeha.Torso4--required to fix a pivot issue
    },
}


entityName = "Loading..."
currentlyUsed = 2

delaySwitchTime = 0
isSwitching = false
ping.switchPlural = function (data)
    delaySwitchTime = 0
    animation.changeClothes.play()
    isSwitching = true
    currentlyUsed = data
end

function tick()
    if isSwitching then
        delaySwitchTime = delaySwitchTime + 1
        if delaySwitchTime > 15 then
            isSwitching = false
            updateModel()
        end
    end
end

function updateModel()
    for index, current in pairs(Plurals) do
        current.modelRoot.setEnabled(index == currentlyUsed)
    end
    nameplate.LIST.setText(Plurals[currentlyUsed].nameplate)
    nameplate.ENTITY.setText(Plurals[currentlyUsed].nameplate)
    entityName = Plurals[currentlyUsed].nameplate
end

updateModel()

action_wheel.SLOT_1.setItem("glass")
action_wheel.SLOT_1.setTitle("Blurry")
action_wheel.SLOT_1.setFunction(function()
    ping.switchPlural(1)
end)

action_wheel.SLOT_2.setItem("beacon")
action_wheel.SLOT_2.setTitle("Leah")
action_wheel.SLOT_2.setFunction(function()
    ping.switchPlural(2)
end)

action_wheel.SLOT_3.setItem("sculk_sensor")
action_wheel.SLOT_3.setTitle("Luke")
action_wheel.SLOT_3.setFunction(function()
    ping.switchPlural(3)
end)

action_wheel.SLOT_4.setItem("axolotl_bucket")
action_wheel.SLOT_4.setTitle("Seha")
action_wheel.SLOT_4.setFunction(function()
    ping.switchPlural(4)
end)

for _, value in pairs(Plurals) do
    value.torso.setPivot{0,-12,0}
end

-- patpat
----------------
rightClick = keybind.newKey("Right Click", "MOUSE_BUTTON_2")

function tick()
    -- if right click
    if player.isSneaky() and rightClick.isPressed() then
        -- get targeted entity
        local entity = player.getTargetedEntity()
        if entity ~= nil and entity.isLeftHanded ~= nil then
            -- swing arm
            renderer.swingArm()

            -- love particles
            local box = entity.getBoundingBox()
            local box2 = box / 2
            local random = {math.random() * box.x - box2.x, math.random() * box.y, math.random() * box.z - box2.z}
            if entity.getType() ~= "minecraft:player" then
                ping.pat(entity.getPos() + vectors.of(random))
            end
        end
    end
end

-- pat particle ping
function ping.pat(arg)
    particle.addParticle("heart", arg)
end

----------------

--- PluralKit

delay = -1
message = ""
function ping.nameplate(x)
    nameplate.CHAT.setText(x)
end
nameplate.CHAT.setText(Plurals[2].nameplate)

chat.setFiguraCommandPrefix("")
function onCommand(cmd)
    for index, current in pairs(Plurals) do
        for _, v in pairs(current.prefixes) do
            if v == string.sub(cmd, 1,#v) then
                delay = 0
                message = cmd:sub(#v + 1)
                ping.nameplate(Plurals[index].nameplate)
                hasPrefix = true
                return
            end
        end
    end
    
    ping.nameplate(LeahName)
    message = cmd
    hasPrefix = false
    chat.setFiguraCommandPrefix(nil)
    chat.sendMessage(message)
    chat.setFiguraCommandPrefix("")
end
function tick()
    if delay >= 0 then
        delay = delay + 1
        if delay == 10 then
            chat.setFiguraCommandPrefix(nil)
            chat.sendMessage(message)
            chat.setFiguraCommandPrefix("")
            hasPrefix = false
        end
        if delay == 20 then
            ping.nameplate(LeahName)
            delay = -1
        end
    end
end

----------

-- eyes blink and movement
-- by Fran#3814 ❤❤❤
-- thx Grandpa Scout#8739 for blink lerp

function player_init()
    TEXTURE_WIDTH = 128 -- texture size (width), in pixels
    TEXTURE_HEIGHT = 128 -- texture size (height), in pixels

    BLINK_MIN_DELAY = 70 -- minimum delay for blink, in ticks
    BLINK_MAX_DELAY = 100 -- maximum delay for blink, in ticks
    BLINK_CHANCE = 0.03 -- chance for blinking after the minimum delay is reached

    DUMMY_BLINK_CHANCE = 0.05 -- chance to make a dummy blink (blink one eye then another)
    DUMMY_BLINK_DELAY = 5 -- delay in ticks to blink the other eye

    -- dont change those
    isBlinking = true
    lblinkFrame = 0
    rblinkFrame = 0
    blinkTick = 0
end

function tick()
    --------------------
    ------ blink -------
    --------------------

    -- tick
    blinkTick = blinkTick + 1

    -- if is already blinking
    if isBlinking then
        -- increase blink frame
        if lblinkFrame < 4 then
            lblinkFrame = lblinkFrame + 1
        end

        if rblinkFrame < 4 then
            rblinkFrame = rblinkFrame + 1
        end

        -- restart blink if frame is greather than 4
        if lblinkFrame >= 4 and rblinkFrame >= 4 then
            isBlinking = false
            blinkTick = 0
        end
        -- check blink
    elseif blinkTick >= BLINK_MIN_DELAY and math.random() < BLINK_CHANCE or blinkTick >= BLINK_MAX_DELAY then
        -- enable blinking
        isBlinking = true
        lblinkFrame = 0
        rblinkFrame = math.random() < DUMMY_BLINK_CHANCE and -DUMMY_BLINK_DELAY or 0
    end
end

function render(delta)
    -------------------
    ---- eyeballs -----
    -------------------

    -- get rot
    local rot = player.getRot(delta)
    local rotX = (player.getBodyYaw(delta) - rot.y) / 45
    local rotY = rot.x / 135

    -- apply
    local eyes = Plurals[currentlyUsed].eyes
    eyes.setPos(math.lerp(eyes.getPos(), vectors.of({0, math.clamp(rotY, -0.45, 0.45), 0}), delta))
    eyes.Left_Iris.setPos(math.lerp(eyes.Left_Iris.getPos(), vectors.of({math.clamp(rotX, -1, 0.15), rotY, 0}), delta))
    eyes.Right_Iris
        .setPos(math.lerp(eyes.Right_Iris.getPos(), vectors.of({math.clamp(rotX, -0.15, 1), rotY, 0}), delta))
    
    --------------------
    ------ blink -------
    --------------------
    
    -- blink uv
    local x = math.clamp(lblinkFrame + delta, 0, 4)
    local lblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))
    
    local x = math.clamp(rblinkFrame + delta, 0, 4)
    local rblink = -4 * math.abs(x / 4 - math.floor(x / 4 + 0.5))

    -- set blink uv
    eyes.Left_Eyelid.setUV({0, lblink / TEXTURE_HEIGHT})
    eyes.Right_Eyelid.setUV({0, rblink / TEXTURE_HEIGHT})
end
----- Nameplate GUI detection -----

function tick()
    --pastMenu = "none"
    pastMenu = menu
    menu = client.getOpenScreen()
    if pastMenu ~= menu then
        ping.nameplateChange()
    end
    
end

ping.nameplateChange = function()
    local openedUI = client.getOpenScreen()
    for key, value in pairs(UI) do
        if key == openedUI then
            nameplate.ENTITY.setText("[" .. entityName .. ',{"text":"\n' .. value ..'", "color": "gray", "italic": true}]')
            return
        end
    end
    nameplate.ENTITY.setText(entityName)
end