---@class renderTask
renderTask = {}

---Sets the Render task Text.  
---note: only if the Render task is Text.
---@param text string
function renderTask.setText(text) end

---Sets the Render task item.  
---note: only if the Render Task is an Item.
---@param item ItemID | BlockID
function renderTask.setItem(item) end

---Sets the Render task Block.  
---note: only if the Render Task is a Block 
---@param block ItemID | BlockID
function renderTask.setBlock(block) end

---Sets the Item render mode.  
---note: only if the render task is an Item.  
---@param mode itemRenderMode
function renderTask.setItemMode(mode) end

---Sets the Render task Render layer.  
---note: only if the render task is **not** Text.
---@param render_layer_name string
function renderTask.setRenderLayer(render_layer_name) end

---Sets if the Render task glows(unshaded).
---@param toggle any
function renderTask.setEmissive(toggle) end

---Returns the Position of the Render Task
function renderTask.getPos() end

---Sets the Position of the Render Task.
---@param pos Vector3
function renderTask.setPos(pos) end

---Returns the Rotation of the Render Task
function renderTask.getRot() end

---Sets the Rotation of the Render Task
---@param rot Vector3
function renderTask.setRot(rot) end

---Returns the Scale of the Render Task
function renderTask.getScale() end

---Sets the Scale of the Render Task.
---@param scl Vector3
function renderTask.setScale(scl) end

---Returns if the Render task is unshaded.
---@return boolean
function renderTask.getEmissive() end

---enables/disables the Render task
---@param toggle boolean
function renderTask.setEnabled(toggle) end

---Returns true if the Render Task is enabled.
---@return boolean
function renderTask.getEnabled() end