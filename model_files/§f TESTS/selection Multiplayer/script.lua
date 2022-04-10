function tick()
    if player.getTargetedBlockPos(false) ~= nil then
        model.NO_PARENTSelection.setPos({
            player.getTargetedBlockPos(false).x*-16,
            player.getTargetedBlockPos(false).y*-16,
            player.getTargetedBlockPos(false).z*16}
        )
    end
end