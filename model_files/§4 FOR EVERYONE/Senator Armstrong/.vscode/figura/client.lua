
---access your client variables only accessible with the host script (local player) using it on non-host will always return nil for everything (except isHost)
client = {}

---note: this will return nil on remote view.
function client.getOpenScreen() end

---note: this will return nil on remote view.
---@return integer
function client.getFPS() end

---note: this will return nil on remote view.
---@return boolean
function client.isPaused() end

---note: this will return nil on remote view.
function client.getVersion() end

---note: this will return nil on remote view.
---@return string
function client.getVersionType() end

---note: this will return nil on remote view.
---@return string
function client.getServerBrand() end

---note: this will return nil on remote view.
---@return integer
function client.getChunksCount() end

---note: this will return nil on remote view.
---@return integer
function client.getEntityCount() end

---note: this will return nil on remote view.
---@return integer
function client.getParticleCount() end

---note: this will return nil on remote view.  
---@return integer
function client.getSoundCount() end

---note: this will return nil on remote view.  
function client.getActiveShader() end

---note: this will return nil on remote view.  
function client.getJavaVersion() end

---Returns the amount of Memory in use.  
---note: this will return nil on remote view.
---@return integer
function client.getMemoryInUse() end

---Returns the Memory capacity.  
---note: this will return nil on remote view.
---@return integer
function client.getMaxMemory() end

---Returns the Allocated memory for the game.  
---note: this will return nil on remote view.
---@return integer
function client.getAllocatedMemory() end

---Returns true if the window is Focused
---note: this will return nil on remote view.
---@return boolean
function client.isWindowFocused() end

---Returns true if the Hud is Enabled.  
---note: this will return nil on remote view.
---@return boolean
function client.isHudEnabled() end

---Returns the window size.  
---note: this will return nil on remote view.
---@return Vector2
function client.getWindowSize() end

---Returns the GUI scale setted in the settings
---Note that GUI scale set to auto wont return the auto GUI scale.  
---another note: this will return nil on remote view.
---@return integer
function client.getGUIScale() end

---Returns the Field of View of the host.  
---note: this will return nil on remote view.
---@return integer
function client.getFov() end

---Returns true if the client is the host of the avatar.
---@return boolean
function client.isHost() end

---Toggles the crosshair.
---@param toggle boolean
function client.setCrosshairEnabled(toggle) end

---Returns true if the crosshair is enabled.
---@return boolean
function client.getCrosshairEnabled() end

---Offsets the chrosshair.
---@param pos Vector2
function client.setCrosshairPos(pos) end

---Returns the crosshair offset.
---@return Vector2
function client.setCrosshairPos() end

---Returns a `Vector2` of the xy, screen relative, of your mouse.
---@return Vector2
function client.getMousePos() end

---Returns the window size based on the gui scale.
---@return Vector2
function client.getScaledWindowSize() end

---Similar to `getGUIScale`, but doesnt freak out when your window is different than the desired (setting) value.
---@return integer
function client.getScaleFactor() end

---Allows you to unlock and lock the mouse while in-game.
function client.setMouseUnlocked() end

---Sets the title text, similar to `/title`.
---@param text string
function client.setTitle(text) end

---Returns the title text.
---@return string
function client.getTitle() end

---Sets the subtitle text, similar to `/title`.
---@param text string
function client.setSubtitle(text) end

---Returns the subtitle text.
---@return string
function client.getSubtitle() end

---Sets the action bar text, similar to `/title` 
---@param text string
function client.setActionbar(text) end

---Returns the action bar text, similar to `/title`
---@return string
function client.getActionbar() end

---changes the Title properties. similar to `/title`
---@param fadeIn number
---@param stay number
---@param fadeOut number
function client.setTitleTimes(fadeIn, stay, fadeOut) end

---Return a boolean if you have an active iris shaders or not.
---@return boolean
function client.getIrisShadersEnabled() end

---Returns a number of the current vertical mouse scroll.
---@return integer
function client.getMouseScroll() end