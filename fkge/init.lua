local cpath = ...
local log = require(cpath..".log")
local spritesheet = require(cpath..".spritesheet")
local viewport = require(cpath..".viewport")

local function tableSelect(aTable, someFields)
	local outTable = {}
	if not aTable then
		return outTable
	end
	for _, key in ipairs(someFields) do
		local value = aTable[key]
		if value then
			outTable[key] = aTable[key]
		end
	end
	return outTable
end

local function tableUpdate(aTable, anotherTable, toDelete)
	for k, v in pairs(anotherTable) do
		aTable[k] = v
	end
	if toDelete then
		for i, k in ipairs(toDelete) do
			aTable[k] = nil
		end
	end
end

local vCfg = {
	width = 360,
	height = 240,
	cameraX = 0,
	cameraY = 0,
}

local components = {}
local systems = {}
local scenes = {}
local entities = {}
local currentScene = {}

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
		currentScene = scene
		scene.init()
		log.debug("Loaded scene '"..name.."'")
	end
end

local function Component(name, parents, data, toDelete)
	local comp = nil

	if not data and parents and type(parents) == 'table' then
		data = parents
		parents = nil
	end

	if data or parents then
		comp = {}
		local names = {}
		if parents then
			for parent in string.gmatch(parents, '[^,%s*]+') do
				local pcomp = Component(parent)
				local pnames = pcomp.names
				tableUpdate(comp, pcomp)
				for _, pname in ipairs(pnames) do
					names[#names+1] = pname
				end
			end
		end
		if data then
			tableUpdate(comp, data, toDelete)
		end
		components[name] = comp
		names[#names+1] = name
		comp.names = names
		comp.name = name
		log.debug("Defined component '"..name.."'")
	else
		comp = components[name]
		if not comp then
			log.warn("Component '"..name.."' does not exist.")
		end
	end

	return comp
end

local function System(name, data)
	local system = nil

	if data then
		systems[name] = data
		log.debug("Defined system '"..name.."'")
	else
		system = systems[name]
		if not system then
			log.error("System '"..name.."' is not defined.")
		end
	end

	return system
end

local entId = 0
local function Entity(name)
	entId = entId + 1

	local entity = {
		id = entId,
	}
	function entity.attr (obj)
		tableUpdate(entity, obj)
		return entity
	end

	local names = {}
	for cname in string.gmatch(name, '[^,%s*]+') do
		local pcomp = Component(cname)
		for _, pname in ipairs(pcomp.names) do
			names[pname] = true
		end
		tableUpdate(entity, pcomp)
		names[cname] = true
	end
	entity.names = names

	if currentScene then
		entities = currentScene.entities
	else
		log.warn("Creating entity in global scope; consider creating a scene.")
	end

	entities[#entities+1] = entity

	log.debug("Created entity "..entId.." of kind '"..name.."'")

	return entity
end

local fkge = {
	scene = Scene,
	component = Component,
	entity = Entity,
	system = System,
	c = Component,
	e = Entity,
	s = System,
}

function love.load()
end

function love.draw()
	viewport.draw()
end

local function draw()
end

function love.update(dt)
	lg.setCanvas(viewport.canvas)

	for _, e in ipairs(entities) do
		for name, func in pairs(systems) do
			if e.names[name] then
				func(e, dt)
			end
		end
	end

	lg.setColor(1, 1, 1)
	lg.setCanvas()
end

function love.resize(w, h)
	viewport.resize(w, h)
end

function fkge.game(config)
	lg.setDefaultFilter('nearest', 'nearest')
	vCfg = tableSelect(config, {"width", "height"})
	viewport.setup(vCfg)

	local tCfg = config.sprites or nil
	if tCfg then
		local sprs = {}
		for imgName, cfg in pairs(tCfg) do
			sprs[imgName] = spritesheet.build(cfg)
		end
		fkge.sprites = sprs
	end
end

return fkge
