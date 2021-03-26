local cpath = string.gsub(..., "%.[^%.]+$", "")
local log = require(cpath..".log")

local components = {}
local systems = {}
local scenes = {}

local function Scene(name, func)
	if func then
		scenes[name] = {
			init = func,
			entities = {},
		}
		log.debug("Defined scene '"..name.."'")
	else
		local scene = scenes[name]
		if not scene then
			message = "Scene '"..name.."' not yet defined!"
			log.error(message)
			error(message, 2)
		end
		log.info("Loading scene '"..name.."'...")
		scene.init()
		log.debug("Loaded scene '"..name.."'")
	end
end

local function Component(name, data)

	log.debug("Defined component '"..name.."'")
end

local function System(name, data)

	log.debug("Defined system '"..name.."'")
end

local entId = 0
local function Entity(name)
	entId = entId + 1

	log.debug("Created entity "..entId.." of kind '"..name.."'")
end

return {
	scene = Scene,
	component = Component,
	entity = Entity,
	system = System,
	c = Component,
	e = Entity,
	s = System,
}
