
pongPos = vectors.of({})
pongVel = vectors.of({})

started = false
startTimer = 20
startupDelay = 20

local screenDim = vectors.of({13/16,7/16})
local pixel = 1/16

monitorPos = vectors.of({})

P1Score = 0
P2Score = 0

movementSpeed = 0.03
pongSpeed = 0.05

lastP1pos = 0
lastP2pos = 0
P1pos = 0
P2pos = 0

player2 = nil

maxThreshold = 5
threshold = 0

action_wheel.SLOT_8.setTitle("Select 2nd Player")
action_wheel.SLOT_8.setItem("minecraft:player_head")
action_wheel.SLOT_8.setFunction(function ()
    local entity = player.getTargetedEntity()
    if entity ~= nil then
        logTableContent(entity)
        if entity.getType() == "minecraft:player" then
            chat.sendMessage("/minecraft:msg "..entity.getName().." I selected you to be the 2nd player of this match")
            log("2nd player setted to "..entity.getName())
        end
    else
        player2 = nil
        log("cleared 2nd player")
    end
end)

action_wheel.SLOT_1.setTitle("Start/Reset")
action_wheel.SLOT_1.setItem("minecraft:spectral_arrow")
action_wheel.SLOT_1.setFunction(function ()
    network.ping("reset")
    log("starting!")
end)

network.registerPing("reset")

moveMonitor = false

network.registerPing("updateMonitorPos")

function updateMonitorPos(pos)
    model.NO_PARENT.setPos(vectors.of({0,-16,0})+pos*vectors.of({-16,-16,16}))
end

action_wheel.SLOT_2.setTitle("move Monitor")
action_wheel.SLOT_2.setItem("minecraft:feather")
action_wheel.SLOT_2.setFunction(function ()
    moveMonitor = not moveMonitor
    if moveMonitor then
        updateMonitorPos(monitorPos)
    end
end)

network.registerPing("updateVel")

function reset()
    sound.playSound("minecraft:block.note_block.bit",monitorPos,{1,1})
    startTimer = 0
    pongPos = vectors.of({})
    started = false
    P1Score = 0
    P2Score = 0
    network.ping("updateVel",vectors.of({lerp(-1,1,math.random(world.getTime())),lerp(-1,1,math.random(world.getTime()))}).normalized()*pongSpeed)
    if math.abs(pongVel.x) > 0.05 then
        network.ping("updateVel",vectors.of({lerp(-1,1,math.random(world.getTime())),lerp(-1,1,math.random(world.getTime()))}).normalized()*pongSpeed)
    end
end

posUpdateTimer = 0

function updateVel(vel)
    pongVel = vel
end

function player_init()
    model.NO_PARENT.setScale({2,2,2})
end

function tick()
    posUpdateTimer = posUpdateTimer + 1
    if posUpdateTimer > 20 then
        updateMonitorPos(monitorPos)
        posUpdateTimer = 0
    end
    if moveMonitor then
        if player.getTargetedBlockPos(false) ~= nil then
            monitorPos = player.getTargetedBlockPos(false)
            model.NO_PARENT.setPos(vectors.of({0,-16,0})+monitorPos*vectors.of({-16,-16,16}))
        end
    end

    lastPongPos = pongPos
    lastP1pos = P1pos
    lastP2pos = P2pos
    startTimer = startTimer + 1
    if startTimer == startupDelay then
        started = true
        sound.playSound("minecraft:block.note_block.bit",monitorPos,{1,1.5})
    end
    if started then
        pongPos = pongPos + pongVel

        threshold = threshold - 0.5
        if math.abs(pongPos.y) > screenDim.y*0.5 then
            pongVel.y = -pongVel.y
            threshold = threshold + 1
        end
        if math.abs(pongPos.x) > screenDim.x*0.5 then
            pongVel.x = -pongVel.x
            threshold = threshold + 1
        end
        if threshold > maxThreshold then
            network.ping("updateVel",vectors.of({lerp(-1,1,math.random(world.getTime())),lerp(-1,1,math.random(world.getTime()))}).normalized()*pongSpeed)
            pongPos = vectors.of({})
        end

        --player 1 pad
        if client.isHost() then
            if player.isSneaky() then
                P1pos = clamp(P1pos + movementSpeed,(-screenDim.y+toPixel(2))*0.5,(screenDim.y-toPixel(2))*0.5)
            else
                P1pos = clamp(P1pos - movementSpeed,(-screenDim.y+toPixel(2))*0.5,(screenDim.y-toPixel(2))*0.5)
            end
            if isPointInsideArea(pongPos,vectors.of({toPixel(-5),P1pos}),vectors.of({toPixel(1),toPixel(4)})) then
                pongVel = vectors.of({0.22,pongPos.y-lastP1pos}).normalized()*-pongSpeed
                sound.playSound("minecraft:block.note_block.bit",monitorPos,{1,1})
            end
        end

        --player 2 pad
        if player2 ~= nil then
            if player2.isSneaky() then
                P2pos = clamp(P2pos + movementSpeed,(-screenDim.y+toPixel(2))*0.5,(screenDim.y-toPixel(2))*0.5)
            else
                P2pos = clamp(P2pos - movementSpeed,(-screenDim.y+toPixel(2))*0.5,(screenDim.y-toPixel(2))*0.5)
            end
        end
        if isPointInsideArea(pongPos,vectors.of({toPixel(5),P2pos}),vectors.of({toPixel(1),toPixel(4)})) then
            pongVel = vectors.of({-0.22,(pongPos.y-lastP2pos)*-1}).normalized()*-pongSpeed
            sound.playSound("minecraft:block.note_block.bit",monitorPos,{1,1})
        end
    end
end

function world_render(delta)
    model.NO_PARENT.screen.pong.setPos(vectors.lerp(lastPongPos,pongPos,delta)*vectors.of({-16,-16,16}))
    model.NO_PARENT.screen.leftPad.setPos({0,lerp(lastP1pos,P1pos,delta)*16})
    
    model.NO_PARENT.screen.rightPad.setPos({0,lerp(lastP2pos,P2pos,delta)*16})
end

function isPointInsideArea(point,centerPos,dimensions)
    local result = false
    if point.x+centerPos.x < dimensions.x*0.5 then
        if point.x+centerPos.x > dimensions.x*-0.5 then
            if point.y+centerPos.y < dimensions.y*0.5 then
                if point.y+centerPos.y > dimensions.y*-0.5 then
                    result = true
                end
            end
        end
    end
    return result
end

function lerp(a, b, x)
    return a + (b - a) * x
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

function toPixel(x)
    return x/16
end