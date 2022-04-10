for key, value in pairs(vanilla_model) do
    value.setEnabled(false)
end

function onDamage()
    sound.playCustomSound("oof",player.getPos(),{1,1})
end