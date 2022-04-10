---@diagnostic disable: undefined-global, undefined-field

function disablemodel(mdl)
    for key, value in pairs(mdl) do
        value.setEnabled(false)
    end
end
model.ANGEL.setScale({0.8,0.8,0.8})
disablemodel(vanilla_model)
disablemodel(armor_model)
elytra_model.LEFT_WING.setScale{0.8,0.8,0.8}
elytra_model.RIGHT_WING.setScale{0.8,0.8,0.8}
elytra_model.LEFT_WING.setPos{0,6,0}
elytra_model.RIGHT_WING.setPos{0,6,0}
---------------
-- Afk Script code --
---------------

-- to rad
function toRad(value)
  return value * math.pi / 180
end

-- vars
function player_init()
  pos  = player.getPos()
  rot  = player.getRot()
  anim = player.getAnimation()
end

name = "Proxima"

-- rainbow
RAINBOW_SPEED = 0
HUE_OFFSET = (8 * RAINBOW_SPEED) / RAINBOW_SPEED
hue = 0

-- nametag
jsonText = {'{"text":"', '","color":"#', '"}'}
for key, value in pairs(nameplate) do
  value.setText(jsonText[1]..name..jsonText[2].."ff72b7"..jsonText[3])
end

function tick()
    rainbow()
    nametag()
end

-- rainbow
function rainbow()
  -- set rainbow color
  hue = ((world.getTime() * RAINBOW_SPEED) % 255) / 255
end

-- nametag
function nametag()

    -- temp varaibles
    local name = name
    local text = '""'
    local text2 = '""'
    local afk = false
    local i = 0
    for c in name:gmatch"." do

    local formatted = ""

    -- ignore spaces
    if c ~= ' ' then

      -- make the color
      color = vectors.hsvToRGB({hue - HUE_OFFSET * i / 255, 0.8, 1})
      color = {
        r = string.format("%x", color.r * 255),
        g = string.format("%x", color.g * 255),
        b = string.format("%x", color.b * 255)
      }

      -- add formatting to the temp text
      formatted = formatted..","..jsonText[1]..c..jsonText[2]..color.r..color.g..color.b..jsonText[3]

      -- increase loop
      i = i + 1
    else

      -- if is a space, dont format it
      formatted = formatted..","..'{"text":" "}'
    end

    -- add to the final text
    text = text..formatted

    -- we dont want the afk text in there
    if afk and i > 5 then
      text2 = text2..formatted
    end
  end

  -- final text formatting
  text = "["..text.."]"
  text2 = "["..text2.."]"

  -- set nameplate text
  nameplate.ENTITY.setText(text)
  nameplate.LIST.setText(text)
 --Afk / Camera Code
  if afk then
    nameplate.CHAT.setText(text2)
  else
    nameplate.CHAT.setText(text)
  end
end
nameplate.ENTITY.setPos({0, -0.5, 0})

action_wheel.setRightSize(2)
action_wheel.setLeftSize(4)

network.registerPing("viewChange")
action_wheel.SLOT_1.setItem("respawn_anchor")
action_wheel.SLOT_1.setTitle("Camera Toggle")
action_wheel.SLOT_1.setFunction(function()
network.ping("viewChange")
sound.playSound("entity.illusioner.prepare_mirror", player.getPos(), {1,1})end)

function viewChange()
    if view then
        camera.THIRD_PERSON.setPos({0, 0, 0})
	    camera.FIRST_PERSON.setPos({0, 0, 0})
    else
        camera.THIRD_PERSON.setPos({0, -0.3, 0})
	    camera.FIRST_PERSON.setPos({0, -0.3, 0})
    end
    view = not view
end

--Sit
network.registerPing("sitToggle")
sit = false
sitIcon = item_stack.createItem("minecraft:oak_stairs")
action_wheel.SLOT_5.setItem(sitIcon)
action_wheel.SLOT_5.setTitle("Sit Toggle")
action_wheel.SLOT_5.setFunction(function() network.ping("sitToggle") end)
model.ANGEL.LA_sit.setEnabled(false)
model.ANGEL.RA_sit.setEnabled(false)
model.ANGEL.LL.setEnabled(false)
model.ANGEL.RL.setEnabled(false)

--Hug
network.registerPing("hugToggle")
hug = false
hugIcon = item_stack.createItem("minecraft:pink_wool")
action_wheel.SLOT_6.setItem(hugIcon)
action_wheel.SLOT_6.setTitle("Hug Toggle")
action_wheel.SLOT_6.setFunction(function() network.ping("hugToggle") end)
model.ANGEL.LA_hug.setEnabled(false)
model.ANGEL.RA_hug.setEnabled(false)

function sitToggle()
  sit = not sit
  hug = false
end

function hugToggle()
  hug = not hug
  sit = false
end

function tick()
  if not sit then
    model.ANGEL.LEFT_ARM.setEnabled(true)
    model.ANGEL.RIGHT_ARM.setEnabled(true)
    model.ANGEL.LEFT_LEG.setEnabled(true)
    model.ANGEL.RIGHT_LEG.setEnabled(true)
    model.ANGEL.LA_sit.setEnabled(false)
    model.ANGEL.RA_sit.setEnabled(false)
    model.ANGEL.LL.setEnabled(false)
    model.ANGEL.RL.setEnabled(false)
    held_item_model.LEFT_HAND.setEnabled(true)
    held_item_model.RIGHT_HAND.setEnabled(true)
    model.ANGEL.setPos({0, 0, 0})
    nameplate.ENTITY.setPos({0, -0.5, 0})
  else
    if player.getVelocity().distanceTo(vectors.of({})) < 0.5 then
      model.ANGEL.LEFT_LEG.setEnabled(false)
      model.ANGEL.RIGHT_LEG.setEnabled(false)
      model.ANGEL.LA_sit.setEnabled(true)
      model.ANGEL.RA_sit.setEnabled(true)
      model.ANGEL.LL.setEnabled(true)
      model.ANGEL.RL.setEnabled(true)
      held_item_model.LEFT_HAND.setEnabled(false)
      held_item_model.RIGHT_HAND.setEnabled(false)
      model.ANGEL.setPos({0, 8, 0})
      nameplate.ENTITY.setPos({0, -1, 0})
    end
  end

  if hug == false then
    model.ANGEL.LEFT_ARM.setEnabled(true)
    model.ANGEL.RIGHT_ARM.setEnabled(true)
    model.ANGEL.LA_hug.setEnabled(false)
    model.ANGEL.RA_hug.setEnabled(false)
  else
    model.ANGEL.LA_hug.setEnabled(true)
    model.ANGEL.RA_hug.setEnabled(true)
  end

  if hug == true or sit == true then
    model.ANGEL.LEFT_ARM.setEnabled(false)
    model.ANGEL.RIGHT_ARM.setEnabled(false)
  end
end

--AFK
afkTimeTick = 0
network.registerPing("yesAfk")
network.registerPing("noAfk")

do
  local hostKey = keybind.newKey("Host check", "F25")
  local isHost = hostKey.getKey() == "F25"
  function player_init() if isHost then host_init() end end
  function tick() if isHost then host_tick() end end
end

function host_init()
  lastPosAFK = player.getPos()
end

function host_tick()
  afkDetect()
end

wasAFK = false

function afkDetect()
	if player.getVelocity().distanceTo(vectors.of({})) < 0.1 then
		afkTimeTick = afkTimeTick + 1
		local afk = afkTimeTick > 300*20
		if wasAFK ~= afk then
			if afk then
				network.ping("yesAfk")
			else
				network.ping("noAfk")
			end
		end
		wasAFK = afk
	else
		afkTimeTick = 0
        sit = false
	end
end

function yesAfk()
  name = "Proxima [AFK]"
  hug = false
  sit = true
  model.ANGEL.LEFT_LEG.setEnabled(false)
  model.ANGEL.RIGHT_LEG.setEnabled(false)
  model.ANGEL.LA_sit.setEnabled(true)
  model.ANGEL.RA_sit.setEnabled(true)
  model.ANGEL.LL.setEnabled(true)
  model.ANGEL.RL.setEnabled(true)
  held_item_model.LEFT_HAND.setEnabled(false)
  held_item_model.RIGHT_HAND.setEnabled(false)
  model.ANGEL.setPos({0, 8, 0})
  nameplate.ENTITY.setPos({0, -1, 0})
end

function noAfk()
  name = "Proxima"
end