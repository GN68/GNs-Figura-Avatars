function tick()
    if world.getTime() % 100 == 0 then
      log("before")
      local biome = world.getBiome(player.getPos())
      log("after " .. tostring(biome))
    end
  end