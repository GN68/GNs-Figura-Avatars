
model.SKULL.reward.bear.setScale({1.5,1.5,1.5})

useKeybind = keybind.getRegisteredKeybind("key.use")
wasPressed = false

opened = false
introDone = false

openTimer = 0
giftPos = nil
introTime = 0
pressed = false
wasOnHead = false
localWasPressed = false

colorIndex = {
    {170, 0, 0}, -- dark red
    {255, 85, 85}, -- red
    {255, 170, 0}, -- gold
    {255, 255, 85}, -- yellow
    {0, 170, 0}, -- dark green
    {85, 255, 85}, -- green
    {85, 255, 255}, -- aqua
    {0, 170, 170}, -- dark aqua
    {0, 0, 170}, -- dark blue
    {85, 85, 255}, -- blue
    {255, 85, 255}, -- light purple
    {170, 0, 170}, -- dark purple
    {255, 255, 255}, -- white
    {170, 170, 170}, -- gray
    {85, 85, 85}, -- dark gray
    {0, 0, 0}, -- black
}
animation.intro.setBlendTime(0)

rewardsCount = 7
rewards = {
    {
        name="Teddy Bear",
        type="toy",
        part=model.SKULL.reward.bear,
        intro=animation.squishIntro,
        outro=animation.squishOutro,
        idle=nil,
        onHeadOffset={0,0,5},
    },
    {
        name="Microwave",
        type="furniture",
        part=model.SKULL.reward.microwave,
        intro=animation.open,
        outro=animation.close,
        idle=nil,
        onHeadOffset={2,1},
    },
    {
        name="Rubber Ducky",
        type="animal",
        part=model.SKULL.reward.duck,
        intro=nil,
        outro=nil,
        idle=animation.duck,
        onHeadOffset={},
    },
    {
        name="Sentry",
        type="furniture",
        part=model.SKULL.reward.sentry,
        intro=animation.sentryShoot,
        outro=nil,
        idle=animation.sentry,
        onHeadOffset={0,-5,0},
    },
    {
        name="Ceilling Fan",
        type="furniture",
        part=model.SKULL.reward.ceillingFan,
        intro=nil,
        outro=nil,
        idle=animation.ceillingfanIdle,
        onHeadOffset={0,-4,0},
    },
    {
        name="Mailbox",
        type="furniture",
        part=model.SKULL.reward.mailbox,
        intro=animation.mailboxOpen,
        outro=animation.mailboxClose,
        idle=nil,
        onHeadOffset={0,-4,0},
    },
    {
        name="Crazy man's Top Hat",
        type="accessory",
        part=model.SKULL.reward.crazyMansTophat,
        intro=animation.squishIntro,
        outro=animation.squishOutro,
        idle=nil,
        onHeadOffset={0,-6.5,0}
    },
    {
        name="Ninja Suit",
        type="skin",
        part=model.SKULL.reward.ninjaSuit,
        intro=animation.squishIntro,
        outro=animation.squishOutro,
        idle=nil,
        onHeadOffset={},
    },
    {
        name="Companion Cube",
        type="furniture",
        part=model.SKULL.reward.companionCube,
        intro=nil,
        outro=nil,
        idle=nil,
        onHeadOffset={},
    },
    {
        name="Tiny Car",
        type="toy",
        part=model.SKULL.reward.tinyCar,
        intro=nil,
        outro=nil,
        idle=nil,
        onHeadOffset={},
    },
    {
        name="Poseidon's Crown",
        type="hat",
        part=model.SKULL.reward.crown,
        intro=nil,
        outro=nil,
        idle=nil,
        onHeadOffset={0,-4,0}
    },
    {
        name="Alarm Clock",
        type="furniture",
        part=model.SKULL.reward.clock,
        intro=animation.squishIntro,
        outro=animation.squishOutro,
        idle=nil,
        alarming=false
    }

}

collected = nil

ping.setSelected = function (selected)
    
    log(selected)
end

function scramble()
    local selected = math.floor(math.lerp(0,#rewards,math.random())+0.5)
    ping.setSelected(selected)
    --collected = rewards[math.floor(math.lerp(math.random(),1,rewardsCount-1))]

    
end

function toggleSuit(toggle)
    model.ninjaSkin.setEnabled(toggle)
    vanilla_model.LEFT_PANTS_LEG.setEnabled(not toggle)
    vanilla_model.RIGHT_PANTS_LEG.setEnabled(not toggle)
    vanilla_model.LEFT_SLEEVE.setEnabled(not toggle)
    vanilla_model.RIGHT_SLEEVE.setEnabled(not toggle)
    vanilla_model.JACKET.setEnabled(not toggle)
    armor_model.HEAD_ITEM.setEnabled(not toggle)
end

function player_init()
    selected = 6
    collected = rewards[selected]
    for key, value in pairs(rewards) do
        value.part.setEnabled(key == selected)
    end
    updt()
    model.SKULL.reward.setEnabled(opened)
    if opened then
        reward_startup()
    end
    model.ninjaSkin.setEnabled(false)
end

ping.open = function (pos)
    opened = true
    animation.intro.play()
    introTime = 0
    giftPos = pos
    updt()
    collected.part.setEnabled(true)
end

ping.input = function (toggle)
    pressed = toggle
end

function reward_startup()
    introDone = true
    updt()
    if collected.idle then
        collected.idle.play()
    end
end

function tick()
    local targetedBlockPos = player.getTargetedBlockPos(false)
    if not introDone then
        if targetedBlockPos then
            local targetedBlock = world.getBlockState(targetedBlockPos).name
            if targetedBlock == "minecraft:player_head" or targetedBlock == "minecraft:player_wall_head" then
                if useKeybind.isPressed() and not opened then
                    openTimer = openTimer + 1
                    if openTimer/2 == math.floor(openTimer/2) then
                        sound.playSound("block.wool.step",targetedBlockPos,{1,openTimer/20})
                    end
                    if openTimer > 1 * 20 then
                        ping.open(targetedBlockPos)
                    end
                else
                    openTimer = 0
                end
            end
        end
        if opened then
            introTime = introTime + 1
            if introTime == 7*20 then
                particle.addParticle("minecraft:dust",targetedBlockPos,{1,1,1,2})
                sound.playSound("block.wool.step",targetedBlockPos,{1,1})
                reward_startup()
            end
        end
    else
        if useKeybind.isPressed() ~= localWasPressed then
            ping.input(useKeybind.isPressed()) 
            
        end
        localWasPressed = useKeybind.isPressed()
        if pressed ~= wasPressed then
            if targetedBlockPos then
                if world.getBlockState(targetedBlockPos).name == "minecraft:player_head" or world.getBlockState(targetedBlockPos).name == "minecraft:player_wall_head" then
                    if wasPressed then
                        if collected.intro then
                            collected.intro.stop()
                        end
                        if collected.outro then
                            collected.outro.play()
                        end
                    else
                        if collected.intro then
                            collected.intro.play()
                        end
                        if collected.outro then
                            collected.outro.stop()
                        end
                    end 
                end
            end
        end
        wasPressed = pressed
    end
    if wasOnHead ~= (player.getEquipmentItem(6).getType() == "minecraft:player_head") then
        wasOnHead = not wasOnHead
        onHead(wasOnHead)
        if collected.name == "Ninja Suit" then
            toggleSuit(wasOnHead)
        end
    end
    if collected then
        if collected.name == "Alarm Clock" then
            model.SKULL.reward.clock.hourHand.setRot{}
        end
    end
end

function onHead(toggle)
    if toggle then
        model.SKULL.setPos(collected.onHeadOffset)
    else
        model.SKULL.setPos{0,0,0}
    end
end

function updt()
    if collected then
        if introDone or opened then
            if introDone then
                model.SKULL.present.setEnabled(not introDone)
            end
            collected.part.setEnabled(true)
            model.SKULL.reward.setEnabled(true)
        else
            model.SKULL.present.setEnabled(not introDone)
            collected.part.setEnabled(introDone)
            model.SKULL.reward.setEnabled(introDone)
        end
    end
end