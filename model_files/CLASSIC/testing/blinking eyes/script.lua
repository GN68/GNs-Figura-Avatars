
function player_init()
    lastBlinkTime = 0.0
end

function tick()
    if math.random() > 0.99 then
        lastBlinkTime = -1
    end
end

function render(delta)
    lastBlinkTime = lastBlinkTime + 0.25
    model.HEAD_eyelid.setScale({1,math.max(math.min(math.abs(lastBlinkTime)*-1+1,1),0),1})
end