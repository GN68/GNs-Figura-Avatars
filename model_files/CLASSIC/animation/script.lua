
--gnsucksLOL
 uuidPaths = {["19ea06a0-0c33-2fce-2ae8-0adb166637e9"]=model.lo.doggo,["292f3839-a60e-454a-92ff-d0c889674e3c"]=model.lo,["bead7dcb-c2d5-642c-4d32-e5202a99d7b7"]=model.lo.doggo.doggo2} animation_tracks = {animation_name={keyframes={["292f3839-a60e-454a-92ff-d0c889674e3c"]={pos={},rot={{-27.5,0,0},{-6.82692,0,0},{13.846161,0,0},{34.519241,0,0},{55.192307,0,0},{75.865379,0,0},{96.53846,0,0},{117.21154,0,0},{137.884613,0,0},{158.557693,0,0},{179.230774,0,0},{174.0625,0,0},{151.666656,0,0},{129.270844,0,0},{106.875,0,0},{84.479164,0,0},{62.083328,0,0},{39.6875,0,0},{17.291664,0,0},{-5.104168,0,0},{-27.5,0,0}},scl={}},["bead7dcb-c2d5-642c-4d32-e5202a99d7b7"]={pos={},rot={},scl={{1,3.1,1},{1,2.96,1},{1,2.82,1},{1,2.68,1},{1,2.54,1},{1,2.4,1},{1,2.26,1},{1,2.12,1},{1,1.98,1},{1,1.84,1},{1,1.7,1},{1,1.56,1},{1,1.42,1},{1,1.28,1},{1,1.14,1},{1,1,1},{1,0.86,1},{1,0.72,1},{1,0.58,1},{1,0.44,1},{1,0.3,1}}}},len=1}}

--states
unpacking = false

playback = 0
currentTrack = "animation_name"

for _, v in pairs(vanilla_model) do
	v.setEnabled(false)
end

function tick()
	if not unpacking then
		
		playback = (playback + 1)%(animation_tracks[currentTrack].len*20)
		
	end
end

function world_render(delta)
	for uuid, index in pairs(animation_tracks[currentTrack].keyframes) do
		if #animation_tracks[currentTrack].keyframes[uuid]["pos"] > playback then
			uuidPaths[uuid].setRot(vectors.of(animation_tracks[currentTrack].keyframes[uuid]["pos"][playback+1])*vectors.of({-1,-1,1}))
		end
		if #animation_tracks[currentTrack].keyframes[uuid]["rot"] > playback then
			uuidPaths[uuid].setRot(vectors.of(animation_tracks[currentTrack].keyframes[uuid]["rot"][playback+1])*vectors.of({-1,1,1}))
		end
		if #animation_tracks[currentTrack].keyframes[uuid]["scl"] > playback then
			uuidPaths[uuid].setScale(vectors.of(animation_tracks[currentTrack].keyframes[uuid]["scl"][playback+1]))
		end
		
	end
end

function lerp(a, b, x)
	return a + (b - a) * x
end

function vector_lerp(a, b, x)
	return vectors.of({lerp(a.x,b.x,x),lerp(a.y,b.y,x),lerp(a.z,b.z,x)})
end