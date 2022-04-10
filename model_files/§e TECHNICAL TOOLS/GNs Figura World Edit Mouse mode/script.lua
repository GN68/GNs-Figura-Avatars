
itterations = 100
stepSize = 0.1

interact = keybind.newKey("Interact","MOUSE_BUTTON_2")
wasInteract = false

selected = false
pointA = nil
pointB = nil

function tick()
    if wasInteract ~= interact.isPressed() then
        if player.getTargetedBlockPos(false) then
            selected = true
            if interact.isPressed() then
                pointA = player.getTargetedBlockPos(false)
            else
                pointB = player.getTargetedBlockPos(false)
                updateSelection()
            end
        else
            selected = false
            updateSelection()
        end
        
    end
    if interact.isPressed() and player.getTargetedBlockPos(false)then
        pointB = player.getTargetedBlockPos(false)
        updateSelection()
    end
    
    wasInteract = interact.isPressed()
end

function updateSelection()
    model.NO_PARENT.SELECTION.setEnabled(selected)
    if selected then
        local startPos = vectors.of{}
        local scale = vectors.of{}
        if pointA.x > pointB.x then
            startPos = vectors.of{pointB.x}
            scale = vectors.of{math.abs(pointA.x-pointB.x)+1}
        else
            startPos = vectors.of{pointA.x}
            scale = vectors.of{math.abs(pointA.x-pointB.x)+1}
        end
        if pointA.y > pointB.y then
            startPos = vectors.of{startPos.x,pointB.y}
            scale = vectors.of{scale.x,math.abs(pointA.y-pointB.y)+1}
        else
            startPos = vectors.of{startPos.x,pointA.y}
            scale = vectors.of{scale.x,math.abs(pointA.y-pointB.y)+1}
        end
        if pointA.z > pointB.z then
            startPos = vectors.of{startPos.x,startPos.y,pointB.z}
            scale = vectors.of{scale.x,scale.y,math.abs(pointA.z-pointB.z)+1}

        else
            startPos = vectors.of{startPos.x,startPos.y,pointA.z}
            scale = vectors.of{scale.x,scale.y,math.abs(pointA.z-pointB.z)+1}
        end
        model.NO_PARENT.SELECTION.setPos(startPos*vectors.of{-16,-16,16})
        model.NO_PARENT.SELECTION.setScale(scale)
        end
    
end

function world_render(delta)
    local trueCameraPos = player.getPos(delta)+vectors.of{0,player.getEyeHeight()}
    model.HUD_GISMO.setPos(anchor({1,1},{-10,-10})) 
    model.HUD_GISMO.y.setRot{-player.getRot().x}
    model.HUD_GISMO.y.xz.setRot{0,player.getRot().y}
end

function anchor(screen_coord,offset)
    return ((client.getWindowSize()*vectors.of{screen_coord[1],screen_coord[2]})/5)/client.getScaleFactor()+vectors.of{offset[1],offset[2]}
end