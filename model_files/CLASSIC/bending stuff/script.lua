jointedLegs = true
jointedArms = true
alternativeLegs = false
alternativeArms = false
leanForward = true
bounceUpAndDown = true

for k,v in pairs(vanilla_model) do
    v.setEnabled(false)
end

function clamp(value,low,high)
    return math.min(math.max(value, low), high)
end

do
    local function lerp(a, b, x)
        return a + (b - a) * x
    end
    local function lerp_3d(a, b, x)
        return {lerp(a[1],b[1],x),lerp(a[2],b[2],x),lerp(a[3],b[3],x)}
    end
    function new_lerped_property(part)
        local ret = {}
        ret.prev_pos = {0,0,0}
        ret.curr_pos = {0,0,0}
        ret.enab_pos = false
        ret.prev_rot = {0,0,0}
        ret.curr_rot = {0,0,0}
        ret.enab_rot = false
        ret.prev_sca = {1,1,1}
        ret.curr_sca = {1,1,1}
        ret.enab_sca = false
        ret.prev_uv = {0,0,0}
        ret.curr_uv = {0,0,0}
        ret.enab_uv = false
        ret.prev_col = {1,1,1}
        ret.curr_col = {1,1,1}
        ret.enab_col = false
        ret.prev_opa = 1
        ret.curr_opa = 1
        ret.enab_opa = false
        function tick()
            ret.prev_pos = ret.curr_pos
            ret.prev_rot = ret.curr_rot
            ret.prev_sca = ret.curr_sca
            ret.prev_uv = ret.curr_uv
            ret.prev_col = ret.curr_col
            ret.prev_opa = ret.curr_opa
        end
        function render(delta)
            if ret.enab_pos then part.setPos(lerp_3d(ret.prev_pos,ret.curr_pos,delta)) end
            if ret.enab_rot then part.setRot(lerp_3d(ret.prev_rot,ret.curr_rot,delta)) end
            if ret.enab_sca then part.setScale(lerp_3d(ret.prev_sca,ret.curr_sca,delta)) end
            if ret.enab_uv then part.setUV(lerp_3d(ret.prev_uv,ret.curr_uv,delta)) end
            if ret.enab_col then part.setColor(lerp_3d(ret.prev_col,ret.curr_col,delta)) end
            if ret.enab_opa then part.setOpacity(lerp(ret.prev_opa,ret.curr_opa,delta)) end
        end
        local function setPos(pos)
            ret.enab_pos = true
            ret.curr_pos = pos
        end
        local function setRot(rot)
            ret.enab_rot = true
            ret.curr_rot = rot
        end
        local function setScale(scale)
            ret.enab_scale = true
            ret.curr_sca = scale
        end
        local function setUV(uv)
            ret.enab_uv = true
            ret.curr_uv = uv
        end
        local function setColor(color)
            ret.enab_col = true
            ret.curr_col = color
        end
        local function setOpacity(opacity)
            ret.enab_opa = true
            ret.curr_opa = opacity
        end
        ret.setPos = setPos
        ret.setRot = setRot
        ret.setScale = setScale
        ret.setUV = setUV
        ret.setColor = setColor
        ret.setOpacity = setOpacity
        return ret
    end
end

lowerLeftLeg = new_lerped_property(model.Player.LeftLeg.LowerLeg)
lowerRightLeg = new_lerped_property(model.Player.RightLeg.LowerLeg)
lowerLeftArm = new_lerped_property(model.Player.LeftArm.LowerArm)
lowerRightArm = new_lerped_property(model.Player.RightArm.LowerArm)
modelplayer = new_lerped_property(model.Player)

RR = 0
_RR = 0
LL = 0
_LL = 0
RA = 0
_RA = 0
LA = 0
_LA = 0
pos = nil
_pos = nil
function player_init()
    pos = player.getPos()
    _pos = player.getPos()
end

function tick()
    if leanForward then
        _pos = pos
        pos = player.getPos()
        local speed = _pos-pos
        speed = vectors.of({speed.x, 0, speed.z}).getLength()*60
        modelplayer.setRot({-speed,0,0})
    end
    if jointedArms then
        _RA = RA
        _LA = LA
        RA = (vanilla_model.RIGHT_ARM.getOriginRot().x*57.3)*1.5
        LA = (vanilla_model.LEFT_ARM.getOriginRot().x*57.3)*1.5
        if alternativeArms then
            lowerRightArm.setRot({math.abs(_RA-RA),0,0})
            lowerLeftArm.setRot({math.abs(_LA-LA),0,0})
        else
            lowerRightArm.setRot({clamp(_RA-RA, 0, 69),0,0})
            lowerLeftArm.setRot({clamp(_LA-LA, 0, 69),0,0})
        end
    end
    if jointedLegs then
        _RR = RR
        _LL = LL
        RR = (vanilla_model.RIGHT_LEG.getOriginRot().x*57.3)*1.5
        LL = (vanilla_model.LEFT_LEG.getOriginRot().x*57.3)*1.5
        if alternativeLegs then
            lowerRightLeg.setRot({-math.abs(RR-_RR),0,0})
            lowerLeftLeg.setRot({-math.abs(LL-_LL),0,0})
        else
            lowerRightLeg.setRot({clamp(RR-_RR, -69, 0),0,0})
            lowerLeftLeg.setRot({clamp(LL-_LL, -69, 0),0,0})
        end
    end
    if bounceUpAndDown then
        modelplayer.setPos({0,math.abs(vanilla_model.RIGHT_LEG.getOriginRot().x*1.5),0})
    end
end

