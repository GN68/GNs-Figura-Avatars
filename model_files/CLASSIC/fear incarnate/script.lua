function disable(stuff)
  for key, value in pairs(stuff) do
    value.setEnabled(false)
  end
end

function player_init()
  disable(vanilla_model)
  disable(armor_model)
  
  model.MIMIC_HEAD.setPos({0, 20, 0})
end