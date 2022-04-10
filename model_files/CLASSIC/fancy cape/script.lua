--functions
function lerp(a, b, x)
	return a + (b - a) * x
end

function clamp(value,low,high)
	return math.min(math.max(value, low), high)
end

--hide vanilla cape
if vanilla_model.CAPE ~= nil then
    vanilla_model.CAPE.setEnabled(false)
end

function if_nil(a, b)
    if a == nil then
        return b
    end
    return a
end

--velocity
old = {}
function player_init()
	pos = player.getPos()
	old.pos = pos
	rot = player.getRot() + vectors.of({0, 0, 0, player.getBodyYaw()})
	old.rot = rot
end

--stuff
cape_parts = {
    model.TORSO_CAPE.bone1,
    model.TORSO_CAPE.bone1.bone2,
    model.TORSO_CAPE.bone1.bone2.bone3,
    model.TORSO_CAPE.bone1.bone2.bone3.bone4,
    model.TORSO_CAPE.bone1.bone2.bone3.bone4.bone5,
    model.TORSO_CAPE.bone1.bone2.bone3.bone4.bone5.bone6,
    model.TORSO_CAPE.bone1.bone2.bone3.bone4.bone5.bone6.bone7
}
cape_rot = vectors.of({0, 0, 0})
old_cape_rot = cape_rot

cape_vel = vectors.of({0, 0, 0})

cape_rots = {}
old_cape_rots = {}

function tick()
    --get velocity
    getVelocity()

    --physics?
    old_cape_rot = cape_rot

    cape_rot = cape_rot+cape_vel
    --
    cape_rot = vectors.of({
        (cape_rot.x*clamp(1-math.abs(vel.t)-math.abs(vel.y)-math.abs(vel.w)*2, 0.2, 1))+-90*clamp(vel.t+math.abs(vel.w*0.005)+math.min(math.abs(vel.h), 0.1), -0.05, 1)+(-120)*clamp(vel.y*0.8, -0.05, 1),
        (cape_rot.y*clamp(1-math.abs(vel.w), 0.2, 1))+90*clamp(vel.w*0.001, -0.05, 0.05),
        (cape_rot.z*clamp(1-math.abs(vel.w)-math.abs(vel.h), 0.2, 1))+90*clamp(vel.w*0.01-vel.h*0.2, -0.35, 0.35)
    })
    --
    cape_vel = vectors.of({
        cape_vel.x*clamp(1-(vel.t-vel.y)*2, 0, 1),
        cape_vel.y,
        cape_vel.z
    })*0.8+cape_rot*-0.06
    --
    if cape_rot.x > 0 then
        if cape_rot.x > 5 then
            cape_vel = vectors.of({cape_vel.x*-0.1, cape_vel.y, cape_vel.z})
        end
        cape_rot = vectors.of({math.min(cape_rot.x*0.5, 5), cape_rot.y, cape_rot.z})
    end  
    for i, v in pairs(cape_rots) do
        old_cape_rots[i] = cape_rots[i]
    end      
    for i = #cape_parts, 1, -1 do
        if cape_parts[i-1] then
            cape_rots[i] = cape_rots[i-1]
        else
            cape_rots[i] = old_cape_rot-cape_rot
        end
    end
end

function render(delta)
    model.TORSO_CAPE.setRot(vectors.lerp(old_cape_rot, cape_rot, delta)+vectors.of({-4, 0, 0}))
    for i, v in pairs(cape_parts) do
        if type(old_cape_rots[i]) == "vector" and type(cape_rots[i]) == "vector" then 
            v.setRot(vectors.lerp(old_cape_rots[i], cape_rots[i], delta))
        end
    end
end

function getVelocity()
	old.rot = rot
	rot = player.getRot() + vectors.of({0, 0, 0, player.getBodyYaw()})
	old.pos = pos
	pos = player.getPos()
	vel = old.pos - pos
	vel = vel + vectors.of({0, 0, 0, 
	rot[4] - old.rot[4],
	math.cos(math.rad(rot.y-90))*vel.x+math.sin(math.rad(rot.y-90))*vel.z,
	math.cos(math.rad(rot.y))*vel.x+math.sin(math.rad(rot.y))*vel.z
	})
end
