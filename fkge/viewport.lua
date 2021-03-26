local lg = love.graphics

local width = 360
local height = 240
local drawFunc = nil
local clamp = "none"

local outputWidth = 1280
local outputHeight = 720
local internalCanvas = nil
local offsetX = 0
local offsetY = 0
local scale = 2

local viewport = {}

function viewport.resize(w, h)
	outputWidth = w
	outputHeight = h
	scale = math.max(1, math.floor(math.min(w / width, h / height)))
	offsetX = math.floor((w - width * scale) * 0.5)
	offsetY = math.floor((h - height * scale) * 0.5)
end

function viewport.draw()
	if not internalCanvas then
		return
	end

	if drawFunc then
		lg.setCanvas(internalCanvas)
		drawFunc()
		lg.setColor(1, 1, 1)
		lg.setCanvas()
	end

	lg.push()
	lg.translate(offsetX, offsetY)
	lg.scale(scale, scale)
	lg.draw(internalCanvas, 0, 0)
	lg.pop()
end

function viewport.setup(config)
	width = config.width or width
	height = config.height or height
	drawFunc = config.drawFunc or drawFunc
	local newClamp = config.clamp or clamp

	viewport.resize(lg.getDimensions())

	if clamp ~= newClamp then
		local w, h = width, height
		if newClamp == "none" then
			w = outputWidth
			h = outputHeight
		elseif newClamp == "wide" then
			w = outputWidth
		end
		internalCanvas = lg.newCanvas(w, h)
		viewport.canvas = internalCanvas
		clamp = newClamp
	end
end

return viewport
