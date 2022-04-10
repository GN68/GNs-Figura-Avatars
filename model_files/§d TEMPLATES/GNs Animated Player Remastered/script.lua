for _, v in pairs(vanilla_model) do
    v.setEnabled(false)
end
model.FLOOR.setEnabled(false)

animation.walk.play()
animation.walk.setSpeed(1)