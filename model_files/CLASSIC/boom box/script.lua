
network.registerPing("updatePosition")
network.registerPing("updateRotation")
playing = true
wasPlaying = true


MovingBoombox = false
if data.load("currentBoomboxPosition") == nil then
    Position = vectors.of({0,0,0})
    data.save("currentBoomboxPosition",Position)
else
    Position = data.load("currentBoomboxPosition")
    network.ping("updatePosition",Position)
end


if data.load("currentBoomboxRotation") == nil then
    model.NO_PARENT_boombox.setRot({0,0,0})
    data.save("currentBoomboxRotation",model.NO_PARENT_boombox.getRot().y)
else
    model.NO_PARENT_boombox.setRot({0,data.load("currentBoomboxRotation"),0})
    network.ping("updateRotation",model.NO_PARENT_boombox.getRot().y)
end
LastPosition = vectors.of({0,0,0})

--action wheel
action_wheel.setRightSize(2)


action_wheel.SLOT_1.setItem(item_stack.createItem("minecraft:jukebox"))
action_wheel.SLOT_1.setTitle("Move the Boombox")
action_wheel.SLOT_1.setFunction(function ()
    MovingBoombox = not MovingBoombox
    if MovingBoombox then
        action_wheel.SLOT_1.setTitle("Place the Boombox")
        sound.playSound("block.wood.break",Position,{1,1})
        wasPlaying = playing
        playing = false
    else
        action_wheel.SLOT_1.setTitle("Move the Boombox")
        sound.playSound("block.wood.place",Position,{1,1})
        data.save("currentBoomboxPosition",Position)
        data.save("currentBoomboxRotation",model.NO_PARENT_boombox.getRot().y)
        if wasPlaying then
            playing = wasPlaying
        end
    end
end)


action_wheel.SLOT_2.setItem(item_stack.createItem("minecraft:prismarine_shard"))
action_wheel.SLOT_2.setFunction(function ()
    playing = not playing
    if playing then
        action_wheel.SLOT_2.setTitle("Pause current playback")
    else
        action_wheel.SLOT_2.setTitle("play current playback")
    end
end)
action_wheel.SLOT_2.setTitle("pause")

--==========================MUSIC TRACKS==============================--
data.save("track1",
{
    title="Demo 1",
    track={
        note={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24},
        timing={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24},
        tps=20
    }
})

data.save("track2",
{
    title="Never gonna give you up",
    track={
        note={1,3,6,3,10,10,8,1,3,6,3,8,8,6,1,3,6,3,6,8,5,3,1,8,6},
        timing={0,1,2,3,5,9,13,20,21,22,23,25,29,33,40,41,42,43,45,49,53,58,61,66,71},
        tps=8
    }
})

track1 = data.load("track1")

action_wheel.SLOT_8.setItem(item_stack.createItem("minecraft:music_disc_cat"))
action_wheel.SLOT_8.setTitle(track1.title)
action_wheel.SLOT_8.setFunction(function ()
    playbackTime = 0
    trackNote = track1.track.note
    trackTiming = track1.track.timing
    tps = track1.track.tps
end)

track2 = data.load("track2")

action_wheel.SLOT_7.setItem(item_stack.createItem("minecraft:music_disc_blocks"))
action_wheel.SLOT_7.setTitle(track2.title)
action_wheel.SLOT_7.setFunction(function ()
    playbackTime = 0
    trackNote = track2.track.note
    trackTiming = track2.track.timing
    tps = track2.track.tps
end)


playbackTime = 0
trackNote = {}
trackTiming = {}
tps = 0

--extras
lastTime = 0

function tick()
    if lastTime ~= math.floor(playbackTime) then
        lastTime = math.floor(playbackTime)
        for key, value in pairs(trackTiming) do
            if math.floor(value) == math.floor(playbackTime) then
                sound.playSound("block.note_block.harp",Position,{1,2^((trackNote[key]-12)/12)})
                particle.addParticle("minecraft:note",vectors.of({Position+vectors.of({math.sin(math.rad(model.NO_PARENT_boombox.getRot().y-90))*((trackNote[key]-12)/24),0.5,math.cos(math.rad(model.NO_PARENT_boombox.getRot().y-90))*((trackNote[key]-12)/24)})}))
            end
        end
    end
    if playing then
        playbackTime = playbackTime + (tps/20)
    end

    if MovingBoombox then
        if player.getTargetedBlockPos(false) ~= nil then
            if world.getBlockState(player.getTargetedBlockPos(false)).isCollidable() then
                Position = player.getTargetedBlockPos(false)+vectors.of({0.5,1,0.5})
            else
                Position = player.getTargetedBlockPos(false)+vectors.of({0.5,0,0.5})
            end
            
            
            model.NO_PARENT_boombox.setRot({0,math.floor(-player.getRot().y/45+0.5)*45+0.5,0})
            model.NO_PARENT_boombox.setOpacity(math.sin(world.getTime()*0.2)*0.25+0.4)
        end
    else
        model.NO_PARENT_boombox.setOpacity(1)
    end
    if LastPosition ~= Position then
        LastPosition = Position
        model.NO_PARENT_boombox.setPos({Position.x*-16,Position.y*-16,Position.z*16})
    end
end

function updatePosition(pos)
    model.NO_PARENT_boombox.setPos({pos.x*-16,pos.y*-16,pos.z*16})
end

function updateRotation(rot)
    model.NO_PARENT_boombox.setRot({0,rot,0})
end