
local boxIndex = {model.NO_PARENT_Selection.cube1,model.NO_PARENT_Selection.cube2,model.NO_PARENT_Selection.cube3,model.NO_PARENT_Selection.cube4,model.NO_PARENT_Selection.cube5,model.NO_PARENT_Selection.cube6,model.NO_PARENT_Selection.cube7,model.NO_PARENT_Selection.cube8,model.NO_PARENT_Selection.cube9,model.NO_PARENT_Selection.cube10,model.NO_PARENT_Selection.cube11,model.NO_PARENT_Selection.cube12,model.NO_PARENT_Selection.cube13,model.NO_PARENT_Selection.cube14,model.NO_PARENT_Selection.cube15,model.NO_PARENT_Selection.cube16,model.NO_PARENT_Selection.cube17,model.NO_PARENT_Selection.cube18,model.NO_PARENT_Selection.cube19,model.NO_PARENT_Selection.cube20,model.NO_PARENT_Selection.cube21,model.NO_PARENT_Selection.cube22,model.NO_PARENT_Selection.cube23,model.NO_PARENT_Selection.cube24,model.NO_PARENT_Selection.cube25}
local maxIndexCount = 25

vineBoom = keybind.newKey("vineBoom","C")

function tick()
    if player.getTargetedBlockPos(false) ~= nil then
        model.NO_PARENT_Selection.setEnabled(true)
        model.NO_PARENT_Selection.setPos(player.getTargetedBlockPos(false)*vectors.of({-16,-16,16}))
        local usedIndex = 1
        for index, currentBox in pairs(world.getBlockState(player.getTargetedBlockPos(false)).getOutlineShape()) do
            usedIndex = usedIndex + 1
            boxIndex[index].setEnabled(true)
            boxIndex[index].setPos({currentBox.x*-16,currentBox.y*-16,currentBox.z*16})
            boxIndex[index].setScale({currentBox.w-currentBox.x,currentBox.t-currentBox.y,currentBox.h-currentBox.z})
        end
        for index = usedIndex, maxIndexCount, 1 do
            boxIndex[index].setEnabled(false)
        end
    else
        model.NO_PARENT_Selection.setEnabled(true)
    end
    if vineBoom.wasPressed() then
        sound.playCustomSound("vineBoom",player.getPos(),{1,1})
    end
    model.NO_PARENT_panel.setRot(player.getRot()*vectors.of({0,-1,1}))
end

pos = nil
_pos = nil
velocity = nil

function player_init()
    pos = player.getPos()
    _pos = pos
    velocity = vectors.of({0})
end

function tick()
    _pos = pos
    pos = player.getPos()
    velocity = pos - _pos
end


function render(delta)
    model.NO_PARENT_panel.setPos(vectors.lerp(player.getPos()-velocity,player.getPos(),delta)*vectors.of({-16,-16,16}))

    local label = "AMOFasdfadfsdfMADOM"
    renderer.renderText(label, model.NO_PARENT_panel,true,{renderer.getTextWidth(label)*-0.2,-16,16},{0,0,0},{1,1,1})
end

function lerp(a, b, x)
    return a + (b - a) * x
end
