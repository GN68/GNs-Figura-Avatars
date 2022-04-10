--=====GNS BALL PHYSICS DEMO=====--

ball = {}

ballcount = 502
--====CONFIG HERO========---
bouncyness = 0.95
margin = 0.01 -- helps avoid balls get stuck on solids
friction = 0.88
explosionPower = 0.8
hasSounds = false
bounceSoundPath = "minecraft:block.note_block.bass"
soundTolerance = 0.1
modelPathName = "NO_PARENT_BALL_"
--==self collisions stuff
selfCollisions = false
ballRadius = 0.5


--========================---
gravity = vectors.of({0,-0.05,0})
thrownIndex = 0

shoot = keybind.getRegisteredKeybind("key.use")
shot = false

network.registerPing("explode")
network.registerPing("throw")

function declareNewBall(index)
    table.insert(ball,{
        model=model[modelPathName..index],
        lastPos=vectors.of({}),
        pos=vectors.of({}),
        vel=vectors.of({}),
        isUsed=false,
    })
    model[modelPathName..index].setColor(vectors.hsvToRGB({(index/ballcount),1,1}))
end
--DECLARATION OF THE BALLS EXISTANCE
function player_init()
    for i = 1, ballcount, 1 do
        declareNewBall(i)
    end
end

action_wheel.SLOT_1.setItem("minecraft:tnt")
action_wheel.SLOT_1.setFunction(function ()
    network.ping("explode")
end)

function tick()
    simulate()
end

--BALL PHYSICS
function simulate()
    --THROW
    if shoot.isPressed() then
        if not shot then
            network.ping("throw")
        end
    end
    shot = shoot.isPressed()
    for _, b in pairs(ball) do
        if b.isUsed then
                b.lastPos = b.pos
                if selfCollisions then
                    for _, e in pairs(ball) do
                        if b.pos.distanceTo(e.pos) < ballRadius then
                            b.vel = b.vel+(b.pos-e.pos).normalized()*0.01 + vectors.of({0,0.01,0})
                        end
                    end 
                end
            -- AXIS X
            local ray = renderer.raycastBlocks(b.pos, b.pos+b.vel*vectors.of({1,0,0}), "COLLIDER", "NONE")
            if ray then--IF ON A WALL
                b.pos = ray.pos + vectors.of({dotp(b.vel.x)*-margin,0,0})
                b.vel = b.vel*vectors.of({-bouncyness,friction,friction})
            else
                b.pos = b.pos+b.vel*vectors.of({1,0,0})
            end
            --AXIS Y
            b.vel = b.vel + gravity
            ray = renderer.raycastBlocks(b.pos, b.pos+b.vel*vectors.of({0,1,0}), "COLLIDER", "NONE")
            if ray then--IF ON A WALL
                b.pos = ray.pos + vectors.of({0,dotp(b.vel.y)*-margin,0})
                b.vel = b.vel*vectors.of({friction,-bouncyness,friction})
            else
                b.pos = b.pos+b.vel*vectors.of({0,1,0})
            end
            --AXIS Z
            ray = renderer.raycastBlocks(b.pos, b.pos+b.vel*vectors.of({0,0,1}), "COLLIDER", "NONE")
            if ray then--IF ON A WALL
                b.pos = ray.pos + vectors.of({0,0,dotp(b.vel.z)*-margin})
                b.vel = b.vel*vectors.of({friction,friction,-bouncyness})
            else
                b.pos = b.pos+b.vel*vectors.of({0,0,1})
            end
        end
    end    
end

-- BALL RENDERING
function world_render(delta)
    for key, b in pairs(ball) do
        if b.isUsed then
            b.model.setPos(vectors.lerp(b.lastPos,b.pos,delta)*vectors.of({-16,-16,16}))
        end
    end
end
--DOT PRODUCT
function dotp(value)
    return value/math.abs(value)
end

function explode()
    for _, b in pairs(ball) do
        b.pos = player.getPos() + vectors.of({0,player.getEyeHeight()})
        b.vel = vectors.of({lerp(-1,1,math.random()),lerp(-1,1,math.random()),lerp(-1,1,math.random())}).normalized()*explosionPower
        b.isUsed = true
    end
end

function throw()
    ball[thrownIndex+1].pos = player.getPos() + vectors.of({0,player.getEyeHeight()})
    ball[thrownIndex+1].vel = player.getLookDir()
    thrownIndex = (thrownIndex + 1) % ballcount
    ball[thrownIndex+1].isUsed = true
end

--LERP MAO
function lerp(a, b, x)
    return a + (b - a) * x
end
