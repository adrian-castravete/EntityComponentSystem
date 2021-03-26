fkge = {}

local cpath = ...
local spritesheet = require(cpath..".spritesheet")
local viewport = require(cpath..".viewport")
local ecs = require(cpath..".ecs")
fkge.ecs = ecs

local tileSize = 8

local stages = {}
local mainStage = nil
local stage = nil

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

local function draw()
	if stage and stage.draw then
		stage.draw()
	end
end

function fkge.game(config)
	local vCfg = tableSelect(config.settings, {"width", "height", "clamp"})
	vCfg.drawFunc = draw
	viewport.setup(vCfg)

	if config.settings then
		tileSize = config.settings.tileSize or 8
	end

	local tCfg = config.sprites or nil
	if tCfg then
		local sprs = {}
		for imgName, cfg in pairs(tCfg) do
			sprs[imgName] = spritesheet.build(cfg)
		end
		fkge.sprites = sprs
	end

	stages = config.stages or {}

	mainStage = config.mainStage or "default"
end

function love.load()
	local stageGen = stages[mainStage] or nil
	if stageGen then
		stage = stageGen()
		if stage.reset then
			stage.reset()
		end
	end
end

function love.draw()
	viewport.draw()
end

function love.update(dt)
	if stage and stage.update then
		stage.update(dt)
	end
end

function love.resize(w, h)
	viewport.resize(w, h)
end

return fkge
