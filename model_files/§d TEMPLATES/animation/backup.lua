--gnsucksLOL


playback = 0
function tick()
	playback = (playback + 1)%#animation
	model.bone.setPos(vectors.of(animation[playback+1]))
end