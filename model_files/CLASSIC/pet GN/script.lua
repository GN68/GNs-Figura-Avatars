--settings
pet = {}
pet.model = model.NO_PARENT_PET
pet.model_head = model.NO_PARENT_PET.head
pet.hitbox = { --change it if u want change hitbox of pet
    {0.4, -0.4, 0.4},
    {-0.4, -0.4, 0.4},
    {0.4, -0.4, -0.4},
    {-0.4, -0.4, -0.4},
    {0.4, 1.4, 0.4},
    {-0.4, 1.4, 0.4},
    {0.4, 1.4, -0.4},
    {-0.4, 1.4, -0.4}
}
pet.show_hitbox = false --enable if you want see pet hitbox
pet.pat_particle = { 0, 0.4, 0 } --shift + right click
pet.legs = { --here are saved legs of pet
    model.NO_PARENT_PET.rightArm,
    model.NO_PARENT_PET.leftArm,
    model.NO_PARENT_PET.rightLeg,
    model.NO_PARENT_PET.leftLeg,
}
pet.distance = 2 --distance when pet should start follow you
pet.stop_distance = {3, 3.5} --distance when pet should stop following you
pet.tp_distance = 20 --distance when pet should tp to you
pet.speed = 4.317/20 --how fast pet should move

--animations ( edit that part if u want change animations )
function render_fix_function(delta)
    --pet position
    pet.model.setPos(vectors.worldToPart(vectors.lerp(pet.old.pos, pet.pos, delta)+vectors.of({0, pet.floor})))
    --pet rotation
    pet.model.setRot({0, lerp_rot(pet.old.body, pet.body, delta)})
    --pet's head rotation
    pet.model_head.setRot({lerp(pet.old.rot.x, pet.rot.x, delta), lerp_rot(pet.old.rot.y, pet.rot.y, delta)-lerp_rot(pet.old.body, pet.body, delta)})
    --pet legs animation
    local pet_speed = math.sqrt(math.pow(pet.vel[1], 2)+math.pow(pet.vel[3], 2))
    local leg_rotation = math.cos((pet.time+delta)*0.75)*math.min(pet_speed*256, 50)
    for i, v in pairs(pet.legs) do
        v.setRot({leg_rotation, 0, 0})
        leg_rotation = leg_rotation * -1
    end
end


--math for pet 
--by dragekk#7300 on discord
local render_fix = 2 --used to fix rendering when player is not rendered
--functions
function lerp(a, b, x)
    return a + (b - a) * x
end

function lerp_rot(a, b, x) --fix rotation when using lerp
    if math.abs((a+360)-b) < math.abs(a-b) then
        a = a+360
    end
    if math.abs((a-360)-b) < math.abs(a-b) then
        a = a-360
    end
    return a + (b - a) * x
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

pet.floor = 0
pet.max_x = 0
pet.max_z = 0
for i, v in pairs(pet.hitbox) do
    pet.max_x = math.max(pet.max_x, v[1])
    pet.floor = math.min(pet.floor, v[2])
    pet.max_z = math.max(pet.max_z, v[3])
end
pet.jump_block_distance = (pet.max_x+pet.max_z)/2+0.4

--sneak and click right click
pet.keybind = keybind.getRegisteredKeybind("key.use")
pet.pat_timer = 7
pet.pat_once = false
pet.pat_animation = {
    {-1.474623, 0.349845, -0.12961318},
    {-1.235969, -0.27274278, -0.28543013},
    {-0.8610104, -0.5764662, -0.34508586},
    {-0.58417875, -0.55078614, -0.29762256},
    {-0.29727453, -0.316857, -0.15688021}
}

pet.fluid_timer = 0
pet.time = 0
pet.follow_distance = 0
pet.follow_speed = 0
player_init_done = false
function player_init()
    player_init_done = true
    respawn_pet()
end

function render(delta)
    render_fix = 2
    render_fix_function(delta)
    local arm = pet.pat_animation[pet.pat_timer]
    if arm == nil then
        arm = {0, 0, 0}
    end
    local arm2 = pet.pat_animation[pet.pat_timer-1]
    if arm2 == nil then
        arm2 = {0, 0, 0}
    end
    local arm = vectors.lerp(vectors.of(arm2), vectors.of(arm), delta)
    vanilla_model.RIGHT_ARM.setRot(arm)
    vanilla_model.RIGHT_SLEEVE.setRot(arm)
end

function pat_pet()
    pet.pat_timer = 0
    for a = 0, math.random(2, 4) do
        local pos = vectors.of(pet.pat_particle)+pet.pos+vectors.of({(math.random()-0.5)*0.8, 0, (math.random()-0.5)*0.8})
        particle.addParticle(
            "minecraft:heart",
            {pos.x, pos.y, pos.z, 0, 0, 0}
        )
    end
end
function respawn_pet()
    if player_init_done then
        pet.pos = player.getPos()+vectors.of({1, 0-pet.floor, 1})
        pet.vel = {0, 0, 0}
        pet.rot = vectors.of({0, 0})
        pet.body = 0
        pet.old = {pos = pet.pos, rot = pet.rot, body = pet.body}
        pet.body_rot = false
    end
    local random_bed = {
        "white",
        "orange",
        "magenta",
        "light_blue",
        "yellow",
        "lime",
        "pink",
        "gray",
        "light_gray",
        "cyan",
        "purple",
        "blue",
        "brown",
        "green",
        "red",
        "black"
    }
    action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:"..random_bed[math.random(1, 16)].."_bed"))
end

network.registerPing("pat_pet")
network.registerPing("respawn_pet")
action_wheel.SLOT_1.setTitle("respawn pet")
action_wheel.SLOT_1.setFunction(function() network.ping("respawn_pet") end)


function tick()
    pet.pat_timer = math.min(pet.pat_timer+1, 7)
    local distance = player.getPos()-pet.pos
    distance = math.sqrt(distance.x*distance.x+distance.y*distance.y+distance.z*distance.z)
    local pat_pos = player.getPos() + vectors.of({0, player.getEyeHeight()}) + player.getLookDir()*vectors.of({distance, distance, distance})
    if pet.keybind.isPressed() then
        if pet.pat_once == false and pet.pat_timer == 7 and player.isSneaky() and distance < 3 then
            if
            math.abs(pat_pos.x - pet.pos.x) < pet.max_x+0.1
                and
            math.abs(pat_pos.y - pet.pos.y) < pet.floor*-1+0.1
                and
            math.abs(pat_pos.z - pet.pos.z) < pet.max_z+0.1
            then
                network.ping("pat_pet")
            end
        end
        pet.pat_once = true
    else
        pet.pat_once = false
    end
    pet.time = pet.time + 1
    --stuff
    local pos = player.getPos()
    render_fix = math.max(render_fix-1, 0)
    if render_fix == 0 then
        render_fix_function(1)
    end
    pet.old = {pos = pet.pos, rot = pet.rot, body = pet.body}
    --rotation
    local xz_distance = pet.pos - pos
    xz_distance = math.sqrt(xz_distance.x*xz_distance.x+xz_distance.z*xz_distance.z)
    pet.rot = {
    math.atan((pet.pos.y-pos.y-player.getEyeHeight())/xz_distance)*-60
    ,
    math.atan((pos.x - pet.pos.x)/(pos.z - pet.pos.z))*60
    }
    if pet.pos.z <= pos.z then
        pet.rot[2] = pet.rot[2]-180
    end
    pet.rot[1] = clamp(pet.rot[1], -40, 40)
    pet.rot = vectors.of(pet.rot)

    pet.body = lerp_rot(pet.body, pet.rot.y, 0.2)

    --physics
    pet_physics(xz_distance)
    --hitbox
    if pet.show_hitbox then
        for i, v in pairs(pet.hitbox) do
            local pos = pet.pos + vectors.of(v)
            particle.addParticle("dust", {
                pos.x, pos.y, pos.z},
                {1, 1, 1, 0.5
            })
        end
    end
end

function pet_physics(xz_distance)
    local distance = player.getPos()-pet.pos
    distance = math.sqrt(distance.x*distance.x+distance.y*distance.y+distance.z*distance.z)
    if pet.distance < distance then
        pet.follow = true
        pet.follow_distance = math.random(pet.stop_distance[1], pet.stop_distance[2])
    end
    if distance < pet.follow_distance then
        pet.follow = false
    end
    if pet.follow then
        if xz_distance < 1 then
            pet.follow_speed = pet.follow_speed*0.8
        else
            pet.follow_speed = lerp(pet.follow_speed, pet.speed, 0.2)
        end
        pet.vel[1] = pet.vel[1] + math.sin(math.rad(pet.rot.y))*pet.follow_speed*-1
        pet.vel[3] = pet.vel[3] + math.cos(math.rad(pet.rot.y))*pet.follow_speed*-1
    else
        pet.follow_speed = pet.follow_speed*0.8
    end
    if distance > pet.tp_distance then
        pet.pos = vectors.of({
            player.getPos().x + math.sin(math.rad(pet.rot.y))
            ,
            player.getPos().y+0.2
            ,
            player.getPos().z + math.cos(math.rad(pet.rot.y))
        })
    end

    if string.match("_minecraft:water_ _minecraft:lava_", world.getBlockState(pet.pos).name) then
        pet.fluid_timer = pet.fluid_timer + 1
        pet.vel[1] = pet.vel[1]*0.5
        pet.vel[2] = pet.vel[2]*0.5
        pet.vel[3] = pet.vel[3]*0.5
        if pet.fluid_timer > 1 then
            pet.vel[2] = pet.vel[2]+0.2
        end
    else
        if pet.fluid_timer > 0 then
            pet.vel[2] = 0.2
        end
        pet.fluid_timer = 0
    end

    local jump_block = pet.pos + vectors.of({
        math.sin(math.rad(pet.rot.y))*pet.jump_block_distance*-1
        , 0, 
        math.cos(math.rad(pet.rot.y))*pet.jump_block_distance*-1
        })
    if check_block(world.getBlockState(jump_block)) then
    elseif pet.follow then
        pet.vel[2] = pet.vel[2] + 0.25
    end

    pet.vel[1] = pet.vel[1]*0.8
    pet.vel[2] = (pet.vel[2]-0.1)*0.95
    pet.vel[3] = pet.vel[3]*0.8
    --check collision without velocity (useful when someone place block inside pet))
    local collision = 0
    local vel = {0, 0, 0}
    for i, v in pairs(pet.hitbox) do
        local block = world.getBlockState(pet.pos+vectors.of(v))
        if check_block(block) == false then
            collision = collision + 1
            vel[1] = vel[1] +v [1]*-1
            vel[2] = vel[2] + v[2]*-1
            vel[3] = vel[3] + v[3]*-1
        end
    end
    pet.vel[1] = pet.vel[1] + vel[1]
    pet.vel[2] = pet.vel[2] + vel[2]
    pet.vel[3] = pet.vel[3] + vel[3]
    --x
    local collision_pos = pet.pos + vectors.of({pet.vel[1]})
    local collision = false
    for i, v in pairs(pet.hitbox) do
        local block = world.getBlockState(collision_pos+vectors.of(v))
        if check_block(block) == false then
            collision = true
        end
    end
    if collision then
        pet.vel[1] = 0
    else
        pet.pos = collision_pos
    end
    --y
    local collision_pos = pet.pos + vectors.of({0, pet.vel[2]})
    local collision = false
    for i, v in pairs(pet.hitbox) do
        local block = world.getBlockState(collision_pos+vectors.of(v))
        if check_block(block) == false then
            collision = true
        end
    end
    if collision then
        pet.vel[2] = 0
        pet.vel[1] = pet.vel[1] * 0.7
        pet.vel[3] = pet.vel[3] * 0.7
    else
        pet.pos = collision_pos
    end
    --z
    local collision_pos = pet.pos + vectors.of({0, 0, pet.vel[3]})
    local collision = false
    for i, v in pairs(pet.hitbox) do
        local block = world.getBlockState(collision_pos+vectors.of(v))
        if check_block(block) == false then
            collision = true
        end
    end
    if collision then
        pet.vel[3] = 0
    else
        pet.pos = collision_pos
    end
end

function check_block(block)
    if string.sub(block.name,-8,-1) == "dripleaf" or
    string.sub(block.name,-8,-1) == "mushroom" or
    string.sub(block.name,-7,-1) == "cluster" or
    string.sub(block.name,-7,-1) == "sapling" or
    string.sub(block.name,-6,-1) == "candle" or
    string.sub(block.name,-6,-1) == "flower" or
    string.sub(block.name,-6,-1) == "button" or
    string.sub(block.name,-6,-1) == "portal" or
    string.sub(block.name,-6,-1) == "carpet" or
    string.sub(block.name,-5,-1) == "plate" or
    string.sub(block.name,-5,-1) == "torch" or
    string.sub(block.name,-5,-1) == "grass" or
    string.sub(block.name,-5,-1) == "roots" or
    string.sub(block.name,-5,-1) == "coral" or
    string.sub(block.name,-5,-1) == "tulip" or
    string.sub(block.name,-5,-1) == "vines" or
    string.sub(block.name,-4,-1) == "fern" or
    string.sub(block.name,-4,-1) == "rail" or
    string.sub(block.name,-3,-1) == "fan" or 
    block.name == "minecraft:air" or 
    block.name == "minecraft:cave_air" or 
    block.name == "minecraft:water" or 
    block.name == "minecraft:lever" or 
    block.name == "minecraft:snow" or 
    block.name == "minecraft:ladder" or 
    block.name == "minecraft:cobweb" or 
    block.name == "minecraft:turtle_egg" or 
    block.name == "minecraft:sea_pickle" or 
    block.name == "minecraft:flower_pot" or 
    block.name == "minecraft:kelp_plant" or 
    block.name == "minecraft:dandelion" or 
    block.name == "minecraft:poppy" or 
    block.name == "minecraft:blue_orchid" or 
    block.name == "minecraft:allium" or 
    block.name == "minecraft:azure_bluet" or 
    block.name == "minecraft:oxeye_daisy" or 
    block.name == "minecraft:lily_of_the_valley" or 
    block.name == "minecraft:wither_rose" or 
    block.name == "minecraft:lilac" or 
    block.name == "minecraft:rose_bush" or 
    block.name == "minecraft:peony" or 
    block.name == "minecraft:vine" or 
    block.name == "minecraft:glow_lichen" or 
    block.name == "minecraft:nether_sprouts" or 
    block.name == "minecraft:redstone_wire" or
    block.name == "minecraft:repeater" or
    block.name == "minecraft:comparator" or
    block.name == "minecraft:tripwire" or
    block.name == "minecraft:tripwire_hook" or
    block.name == "minecraft:scaffolding" then
        return true
    else
        return false
    end
end