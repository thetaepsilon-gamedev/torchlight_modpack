local wieldhooks = modns.get("com.github.thetaepsilon.minetest.libmt_wield_hooks")

local warning = function(msg)
	minetest.log("warning", "[handheld_torch] "..msg)
end

-- TODO: make this configurable to help alleviate server lag
local master_interval = 0.28

-- map from an object reference to their associated light entity.
local active_lights = {}
-- registered shine intensities for held items
local registry= {}

local remove_light = function(objectref)
	local light = active_lights[objectref]
	active_lights[objectref] = nil
	if light == nil then
		warning("remove_light() called for an entity with no light! "..tostring(objectref))
		return
	end

	-- detach the light entity if it's not already to cause it to clean itself up.
	light:set_detach()
end

local hand_offset = vector.new(0, 1, 0)
local add_light = function(objectref, itemstack)
	-- spawn light at the player's approximate relative hand position
	local name = itemstack:get_name()
	local def = registry[name]
	if def == nil then
		warning("add_light() called for unregistered item "..name)
	else
		local staticdata = minetest.write_json({
			lightlevel=def.level,
			offset=hand_offset,
			interval=master_interval,
			kill_on_detach=true,
		})
		local ent = minetest.add_entity(objectref:get_pos(), "lightentity:light", staticdata)
		ent:set_attach(objectref, "handheld_light", {}, {})
		active_lights[objectref] = ent
	end
end



local validate_reg_entry = function(source)
	if type(source.intensity) ~= "number" then error("validate_reg_entry() intensity expected to be an integer") end
	return source
end

local interface = {}
handheld_torch = interface


local hooks = {
	on_wield_start = add_light,
	on_wield_stop = remove_light,
	on_player_vanished = remove_light,
}
local register_handheld_light = function(itemname, def)
	local dname = "register_handheld_light() "
	if type(itemname) ~= "string" then error(dname.."item name must be a string!") end
	def = validate_reg_entry(def)
	if registry[itemname] ~= nil then
		error(dname.."duplicate registration for "..itemname)
	end
	registry[itemname] = def

	wieldhooks.register_wield_hooks(itemname, hooks)
end
interface.register_handheld_light = register_handheld_light

-- register base game's torch
local torchname = "default:torch"
local torchdef = minetest.registered_nodes[torchname]
if torchdef then
	local level = torchdef.light_source
	if type(level) ~= "number" then
		warning(torchname.." isn't a light source!?")
	else
		register_handheld_light(torchname, {intensity=level})
	end
end
