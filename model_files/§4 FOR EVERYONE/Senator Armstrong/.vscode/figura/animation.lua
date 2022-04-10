---@class AnimationTrack
local AnimationTrack = {}

---@class animation
---@type table<string, AnimationTrack>
animation = {}

---@class animationTrack
animationTrack = {}

---@alias playbackMode
---|'"HOLD"' Pauses on last frame
---|'"LOOP"' Loops animation
---|'"ONCE"' Holds still on last frame.


---@alias playStates
---| '"STOPPED"'
---| '"PLAYING"'
---| '"PAUSED"'
---| '"ENDED"'
---| '"STOPPING"'
---| '"STARTING"'

---Stops all playing animations.
function animation.stopAll() end

---Returns the animation track.
---@param name animation[]
function animation.get(name) end

---Ceases all playing animation.
function animation.ceaseAll() end

---@return integer
function animation.getCurrentAnimationCount() end


---Starts the animation.
function AnimationTrack.play() end

---Stops the animation
function AnimationTrack.stop() end

---Stops the animation without blending.
function AnimationTrack.cease() end

---Returns the animation length (in seconds).
---@return number
function AnimationTrack.getLength() end

---Sets the speed of the animation  
---note: default is 1
---@param speed number
function AnimationTrack.setSpeed(speed) end

---Returns the speed of the animation  
---note: default is 1
---@return number
function AnimationTrack.getSpeed() end

---Sets the playback.
---@param mode playbackMode
function AnimationTrack.setLoopMode(mode) end

---Returns the loop mode.
---@return string
function AnimationTrack.getLoopMode() end

---Sets the animation Track length (in seconds).  
---note: setting this to a value below the original length will cause the animation to terminate before it completes
---@param len number
function AnimationTrack.setLength(len) end

---Returns if the animation is playing.  
---note that this will return false if the animation loop mode is set to `ONCE` and the track stops at the end.
---@return boolean
function AnimationTrack.isPlaying() end

---Returns the time to skip when playing the animation.
---@return number
function AnimationTrack.getStartOffset() end

---Sets the time to skip when playing the animation.
---@param offset number
function AnimationTrack.setStartOffset(offset) end

---Returns the Blend Weight of the animation.
---@return number
function AnimationTrack.getBlendWeight() end

---a multiplier for the keyframe values.  
---weight range is `0` to `1`
---@param weight any
function AnimationTrack.setBlendWeight(weight) end

---Returns the start delay of the animation.  
---delay is in seconds.
---@return number
function AnimationTrack.getStartDelay() end

---Sets the start delay of the animation.  
---delay is in seconds.
---@param delay number
function AnimationTrack.setStartDelay(delay) end

---Returns the delay before the animation loops.  
---delay is in seconds.
---@return number
function AnimationTrack.getLoopDelay() end

---sets the delay before the animation loops(if the animation is on loop).  
---delay is in seconds.
---@param delay any
function AnimationTrack.setLoopDelay(delay) end

---sets the playstates manually
---@param playState playStates
function AnimationTrack.setPlayState(playState) end

---Sets the time to blend(in seconds).
---@param number number
function AnimationTrack.setBlendTime(number) end

---Returns the time to blend.
---@return number
function AnimationTrack.getBlendTime() end

---this option "locks" vanilla rotations, however the pivots are still applied.  
--- similar to how mimic parts work, but instead of only rotations, it is only for positions.
---@param toggle boolean
function AnimationTrack.setReplace(toggle) end

---Returns true if the animation replaces the vanilla animations.
---@return boolean
function AnimationTrack.getReplace() end

---higher layer = overwrites lower layers.
---@param layer integer
function AnimationTrack.setPriority(layer) end

---Returns the priority layer of the animation.
---@return integer
function AnimationTrack.getPriority() end