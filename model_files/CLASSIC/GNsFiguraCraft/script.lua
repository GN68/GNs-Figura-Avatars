currentPlayerRot = nil
lastPlayerRot = nil
velocity = nil

mouseSnesitivity = 0.3

mouseScreenPos = vectors.of({})
lastMousePos = vectors.of({})
mousePos = vectors.of({})
mouseVel = vectors.of({})

leftMouse = keybind.getRegisteredKeybind("key.attack")
rightMouse = keybind.getRegisteredKeybind("key.use")

model.HUD.setPos({0,0,-187})

model.HUD.playground.setScale({0.5,0.5,0.5})

function world_render(delta)
    mouseScreenPos = {
        x=(((player.getRot().y/90)+1)%2)-1,
        y=player.getRot().x/90}
        lastMousePos = mousePos
    mousePos = vectors.of({mouseScreenPos.x,mouseScreenPos.y})*(vectors.of({client.getWindowSize().x,client.getWindowSize().y})/vectors.of({16,16}))
    model.HUD.cursor.setPos(mousePos)

    mouseVel = lastMousePos-mousePos
    
    if rightMouse.isPressed() then
        model.HUD.playground.setRot(model.HUD.playground.getRot()+(vectors.of({mouseVel.y,mouseVel.x})*vectors.of({4,0})))
        model.HUD.playground.offset.setRot(model.HUD.playground.offset.getRot()+(vectors.of({mouseVel.y,mouseVel.x})*vectors.of({0,-4})))
    end

end

function lerp(a, b, x)
    return a + (b - a) * x
end

