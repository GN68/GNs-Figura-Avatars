
function player_init()
    lastRot = player.getRot()

    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

pos = nil
_pos = nil
velocity = nil

function tick()
    rot = player.getRot()
    local diffRot = rot-lastRot
    diffRot = diffRot + vectors.of({0,0,math.sin(math.rad(rot.x))*diffRot.y})
    localVel = {
        x=(math.sin(math.rad(-player.getRot().y))*velocity.x)+(math.cos(math.rad(-player.getRot().y))*velocity.z),
        0,
        z=(math.sin(math.rad(-player.getRot().y+90))*velocity.x)+(math.cos(math.rad(-player.getRot().y+90))*velocity.z)
    }

    model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.part8.part9.part10.setRot(model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.part8.part9.getRot())
    model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.part8.part9.setRot(model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.part8.getRot())
    model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.part8.setRot(model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.getRot())
    model.HEAD.part0.part1.part2.part3.part4.part5.part6.part7.setRot(model.HEAD.part0.part1.part2.part3.part4.part5.part6.getRot())
    model.HEAD.part0.part1.part2.part3.part4.part5.part6.setRot(model.HEAD.part0.part1.part2.part3.part4.part5.getRot())
    model.HEAD.part0.part1.part2.part3.part4.part5.setRot(model.HEAD.part0.part1.part2.part3.part4.getRot())
    model.HEAD.part0.part1.part2.part3.part4.setRot(model.HEAD.part0.part1.part2.part3.getRot())
    model.HEAD.part0.part1.part2.part3.setRot(model.HEAD.part0.part1.part2.getRot())
    model.HEAD.part0.part1.part2.setRot(model.HEAD.part0.part1.getRot())
    model.HEAD.part0.part1.setRot(model.HEAD.part0.getRot())
    model.HEAD.part0.setRot({diffRot.x+(localVel.x*15),0,diffRot.z+(localVel.z*-15)})

    lastRot = player.getRot()

    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
end