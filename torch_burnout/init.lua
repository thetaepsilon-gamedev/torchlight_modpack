local modname = minetest.get_current_modname()
local nodename = modname..":used_torch"

local texturemod = "torch_burnout_charred.png^(default_torch_on_floor.png^[mask:torch_burnout_handle_mask.png)"
minetest.register_node(nodename, {
	description = "Burned-out torch (you HAAAAAX!)",
	groups = { choppy=1, oddly_breakable_by_hand=1 },
	tiles = { texturemod },
	inventory_image = texturemod,
	drawtype = "torchlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propogates = true,
})
