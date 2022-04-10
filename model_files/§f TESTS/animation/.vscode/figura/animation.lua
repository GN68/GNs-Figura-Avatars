---@class AnimationTrack
local AnimationTrack = {}

---@type table<string, AnimationTrack>
animation = {}

---@class animationTrack
animationTrack = {}

---@alias playbackMode
---|"HOLD" Pauses on last frame
---|"LOOP" Loops animation
---|"ONCE" Holds still on last frame.

---Starts the animation.
function animationTrack.play() end

---Stops the animation
function animationTrack.stop() end

---Stops the animation without blending.
function animationTrack.cease() end

---Returns the animation length (in seconds).
---@return number
function animationTrack.getLength() end

---Sets the speed of the animation  
---note: default is 1
---@param speed number
function animationTrack.setSpeed(speed) end

---Returns the speed of the animation  
---note: default is 1
---@return number
function animationTrack.getSpeed() end

---Sets the playback
---@param mode playbackMode
function animationTrack.setLoopMode(mode) end