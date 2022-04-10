
instance = {}
chunk = {}

originDomain = vectors.of{1748,67,1761}
domainSize = vectors.of{17,5,10}

throw = keybind.newKey("R","R")

sphereCount = 60

function instanceNewObject(id)
    table.insert(instance,id,{
        position = vectors.of({originDomain.x+domainSize.x*0.5,originDomain.y+domainSize.y*0.5,originDomain.z+domainSize.z*0.5}),
        velocity = vectors.of({0,0,0}),
        lastPosition = vectors.of({}),
        id = id,
        lastchunkID = nil
    })
    --model["NO_PARENT"..tostring(id)]["CAMERA"..tostring(id)].addRenderTask("TEXT", "id", tostring(id))
    model["NO_PARENT"..tostring(id)].setColor(vectors.hsvToRGB({id*1.1111111,1,1}))
end

function player_init()
    log("instancing..")
    for index = 1, sphereCount, 1 do
        instanceNewObject(index)
    end
    log("finished (count: "..sphereCount..")")
    log("instancing chunk cells")
    local cellCount = 0
    for x = 1, domainSize.x, 1 do
        chunk[x] = {}
        for y = 1, domainSize.y, 1 do
            chunk[x][y] = {}
            for z = 1, domainSize.z, 1 do
                chunk[x][y][z] = {}
                cellCount = cellCount + 1
            end
        end
    end
    log("cells instanced ( Cell count: "..cellCount..")")
end

network.registerPing("thrw")

c = 0
function thrw()
    c = (c+1) % sphereCount
    instance[c+1].position = player.getPos()+vectors.of({0,player.getEyeHeight()})
    instance[c+1].velocity = player.getLookDir()
end


function tick()
    if throw.wasPressed() then
        network.ping("thrw")
    end
    for index, p in pairs(instance) do
        --============ [ PHYICS ] ============--
        p.lastPosition = p.position
        p.position = p.position + p.velocity
        p.velocity = p.velocity + vectors.of({0,-0.05,0})
        if chunk[math.floor(p.position.x-originDomain.x)] then
            if chunk[math.floor(p.position.x-originDomain.x)][math.floor(p.position.y-originDomain.y)] then
                if chunk[math.floor(p.position.x-originDomain.x)][math.floor(p.position.y-originDomain.y)][math.floor(p.position.z-originDomain.z)] then
                    chunk[math.floor(p.position.x-originDomain.x)][math.floor(p.position.y-originDomain.y)][math.floor(p.position.z-originDomain.z)][p.id] = true
                    if p.lastchunkID ~= nil then
                        chunk[p.lastchunkID.x][p.lastchunkID.y][p.lastchunkID.x][p.id] = false
                    end
                    p.lastchunkID = vectors.of{math.floor(p.position.x-originDomain.x),math.floor(p.position.y-originDomain.y),math.floor(p.position.z-originDomain.z)}
                end
            end
        end
        
        p.position = vectors.of({clamp(p.position.x,originDomain.x+0.5,originDomain.x+domainSize.x-0.5),clamp(p.position.y,originDomain.y+0.5,originDomain.y+domainSize.y-0.5),clamp(p.position.z,originDomain.z+0.5,originDomain.z+domainSize.z-0.5)})
        local lastP = p.position
        

        p.velocity = p.velocity * vectors.of({0.9,1,0.9})
        for _ = 1, 1, 1 do
            --============ [ SELF COLLISIONS ] ============--
            for indx = 1, sphereCount, 1 do
                if indx ~= p.id then
                    if p.position.distanceTo(instance[indx].position) < 1 then
                        local b = instance[indx]
                        local normal = (p.position-b.position).normalized()
                        local deepness = (1+(b.position-p.position).getLength()*-1)
                        p.velocity = p.velocity + normal*deepness
                        p.position = p.position + normal.normalized()*deepness
        
                        b.velocity = b.velocity - normal*deepness
                        b.position = b.position - normal*deepness
                    end
                end
            end
            
            --============ [ PLAYER COLLISIONS ] ============--
            local players = world.getPlayers()
            for current, value in pairs(players) do
                if p.position.distanceTo(value.getPos()) < 1 then
                    local pPos = value.getPos()+vectors.of({0,0.5,0})
                    local normal = (pPos-p.position).normalized()*(1+(pPos-p.position).getLength()*-1)
                    p.velocity = p.velocity - normal
                    p.position = p.position - normal
                end
            end
            
            if (lastP-p.position).getLength() > 0 then
                p.velocity = (p.velocity*0.8) + vectors.of({lerp(-0.001,0.001,math.random()),lerp(-0.001,0.001,math.random()),lerp(-0.001,0.001,math.random())})
            end
        end
    end
end

function world_render(delta)
    for index, p in pairs(instance) do
        model["NO_PARENT"..tostring(index)].setPos(vectors.lerp(p.lastPosition,p.position,delta)*vectors.of({-16,-16,16}))
    end
end

function lerp(a, b, x)
    return a + (b - a) * x
end


function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end