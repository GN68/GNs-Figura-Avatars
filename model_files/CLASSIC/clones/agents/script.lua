position = vectors.of({})
velocity = vectors.of({})
targetRotation = vectors.of({})
distanceWalked = 0
distVelocity = 0
offsetTarget = vectors.of({})
wanderTimer = 0
updateTimer = 0
lastPos = position
--=============-------CONFIG=============-------
--======MODEL PATHS==========
--note: set the path to nil if it dosent exist
characterRoot = model.NO_PARENT.AGENT1
Head = characterRoot.H
LeftArm = characterRoot.LA
RightArm = characterRoot.RA
LeftLeg = characterRoot.LL
RightLeg = characterRoot.RL
--===========BEHAVIOUR==================--
walk_if_distance_to_player_is_greater_than = 1
sprint_if_distance_to_player_is_greater_than = 5
teleport_if_distance_to_player_is_greater_than = 32

walkSpeed= 0.1
sprintSpeed = 0.15
jumpHeight = 0.4
friction = vectors.of({0.6,1,0.6})
gravity = vectors.of({0,-0.08})

wanderRadius = 6 --how far can your agent wander
minWanderTime = 1 --based on seconds
maxWanderTime = 3

--water stuff
waterFriction = vectors.of({0.7,0.8,0.7})
floatVelocity = vectors.of({0,0.1,0})

--==developer config
debPos = false --logs remote position
--==============END OF CONFIG===================--
network.registerPing("updatePos")
finishedLoading = false
function player_init()
    characterRoot.setScale({0.95,0.95,0.95})
    position = player.getPos()
    finishedLoading = true
end

function tick()
    if client.isHost() then
        --position update for remote viewers
        updateTimer = updateTimer + 1
        if updateTimer > 5 then
            network.ping("updatePos",position)
            updateTimer = 0
        end
        --velocity and position
        position = position + velocity
        velocity = velocity * friction
        --collision
        local coll = collision(position)
        position = coll.position
        velocity = velocity + gravity
        if coll.isColliding then
            velocity.y = 0.0001
        end
        --player distance stuff
        local distanceToPlayerXZ = vectors.of({position.x,0,position.z}).distanceTo((vectors.of({player.getPos().x,0,player.getPos().z})+offsetTarget))
        if distanceToPlayerXZ > walk_if_distance_to_player_is_greater_than then
            local movement = (player.getPos()-position+offsetTarget).normalized()*0.1
            
            if distanceToPlayerXZ > sprint_if_distance_to_player_is_greater_than then
                movement = (player.getPos()-position+offsetTarget).normalized()*0.15
                if coll.isColliding then
                    velocity.y = jumpHeight
                end
            end
            velocity = velocity + vectors.of({movement.x,0,movement.z})
        end
        if position.distanceTo(player.getPos()) > teleport_if_distance_to_player_is_greater_than then
            position = player.getPos()
            velocity = vectors.of({0,0,0})
        end
            
        if world.getBlockState(position+vectors.of({0,0.5,0})).name == "minecraft:water" then
            velocity = velocity * waterFriction
            velocity = velocity + floatVelocity
        end

        distVelocity = vectors.of({}).distanceTo(vectors.of({velocity.x,0,velocity.z}))
        distanceWalked = distanceWalked + distVelocity
            
        if wanderTimer < 0 then
            wanderTimer = lerp(minWanderTime*20,maxWanderTime*20,math.random())
            offsetTarget = vectors.of({math.random()*wanderRadius-(wanderRadius*0.5),0,math.random()*wanderRadius-(wanderRadius*0.5)})
        end
        wanderTimer = wanderTimer - 1
    end
end

function world_render(delta)
    characterRoot.setPos(vectors.lerp(characterRoot.getPos(),vectors.of({position.x*-16,position.y*-16,position.z*16}),delta))
    
    if velocity.distanceTo(vectors.of({})) > 0.01 then
        characterRoot.setRot({0,lerp_angle(characterRoot.getRot().y,math.deg(math.atan2(velocity.x,velocity.z))+180,delta)})
    end
    local lukat = velocity * vectors.of({-1,-1,-1})
        
    local swing = (math.sin(distanceWalked*2.3)*45)*math.min(distVelocity*32,1)
    if LeftLeg ~= nil then
        LeftLeg.setRot({lerp(LeftLeg.getRot().x,swing,delta)})
    end
    if RightLeg ~= nil then
        RightLeg.setRot({lerp(RightLeg.getRot().x,-swing,delta)})
    end
    if LeftArm ~= nil then
        LeftArm.setRot({lerp(LeftArm.getRot().x,-swing,delta)})
    end
    if RightArm ~= nil then
        RightArm.setRot({lerp(RightArm.getRot().x,swing,delta)})
    end

    if not client.isHost() then
        velocity = position-lastPos
        lastPos = position
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function lerp_angle(a, b, x)
    local diff = (b-a)
    local delta = diff-(math.floor(diff/360)*360)
    if delta > 180 then
        delta = delta - 360
    end
    return a + delta * x
end

function updatePos(pos)
    if not client.isHost() then
        position = pos
    end
    if debPos then
        log("pos update:\nx="..position.x.."\ny="..position.y.."\nz="..position.z)
    end
end

--collision detection by GNamimates#9366
--give it a 3D position and it will return back the position but adjusted to the closest surface
function collision(pos)-- sorry idk what to name this lmao
    local point = vectors.of({pos.x,pos.y,pos.z})
    local collision = world.getBlockState(point).getCollisionShape()
    local blockPos = vectors.of({point.x-math.floor(point.x),point.y-math.floor(point.y),point.z-math.floor(point.z)})
    local iscoll = false

    for index, value in ipairs(collision) do--loop through all the collision boxes
        if value.x < blockPos.x and value.w > blockPos.x then-- checks if inside the collision box
            if value.y < blockPos.y and value.t > blockPos.y then
                if value.z < blockPos.z and value.h > blockPos.z then
                    --detected inside the cube
                    local currentPoint = point--for somethin idk
                    --finding the closest surface from the cube
                    point.y = math.floor(currentPoint.y)+value.t
                    iscoll = true
                end
            end
        end
    end
    return {position=point,isColliding=iscoll}
end