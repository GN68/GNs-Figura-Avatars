
function player_init()
    time = 0
end

function tick()
    time = time + 1
    model.HEAD_eyes.cube.setScale({1,math.min(math.max(math.abs(math.sin(time*0.05)*5),0),1),1})
    --log(time)
end