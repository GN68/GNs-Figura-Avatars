--[[--====================================================================---------
░██████╗░███╗░░██╗░█████╗░███╗░░░███╗██╗███╗░░░███╗░█████╗░████████╗███████╗░██████╗
██╔════╝░████╗░██║██╔══██╗████╗░████║██║████╗░████║██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║░░██╗░██╔██╗██║███████║██╔████╔██║██║██╔████╔██║███████║░░░██║░░░█████╗░░╚█████╗░
██║░░╚██╗██║╚████║██╔══██║██║╚██╔╝██║██║██║╚██╔╝██║██╔══██║░░░██║░░░██╔══╝░░░╚═══██╗
╚██████╔╝██║░╚███║██║░░██║██║░╚═╝░██║██║██║░╚═╝░██║██║░░██║░░░██║░░░███████╗██████╔╝
░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░
--=================================================================================--]]
for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end
for _, v in pairs(armor_model) do
    v.setEnabled(false)
end
model.origin.setPos{0,24,0}

animation.walkF.setBlendTime(0.2)
animation.walkF.setSpeed(2.1)
animation.walkB.setBlendTime(0.2)
animation.walkB.setSpeed(2.1)

--[[===================================== [ DYNAMIC VALUES ] =============================================]]--
stateMachine = {
    states = {}
}

localVel = nil
velocity = nil
--[[====================================== [ GENERAL ] ============================================]]--

function tick()
    velocity = player.getVelocity()
    localVel = vectors.of{
        (math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z),
        0,
        (math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z)
    }
    if localVel.z > 0.1 then
       stateMachine.set("walk","walkF")
    else
        if localVel.z < -0.1 then
            stateMachine.set("walk","walkB")
         else
            stateMachine.set("walk",nil)
         end
    end
end

function stateMachine.set(name,value)
    if not stateMachine.states[name] then
        stateMachine.states[name] = {old=nil,new=value}
    else
        stateMachine.states[name].new = value
        if stateMachine.states[name].old ~= stateMachine.states[name].new then
            if stateMachine.states[name].old ~= nil then
                animation[stateMachine.states[name].old].stop()
            end
            if stateMachine.states[name].new ~= nil then
                animation[stateMachine.states[name].new].play()
            end
            stateMachine.states[name].old = stateMachine.states[name].new
        end
    end
end