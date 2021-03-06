lg = love.graphics
fkge = require'fkge'

fkge.game {
	width = 256,
	height = 192,
}

fkge.c('2d', {
	x = 0,
	y = 0,
	w = 8,
	h = 8,
})

fkge.c('color', {
	color = {4/7, 4/7, 2/3},
})

fkge.c('draw', "2d, color")

fkge.c('ship', "draw, input", {
	w = 16,
	h = 16,
	pressedLeft = false,
	pressedRight = false,
	pressedFire = false,
	joy = 'center',
	fireDelta = 0,
})

fkge.s('ship', function (e, _, dt)
	if e.pressedLeft or e.joy == 'left' then
		e.x = e.x - 2
	end
	if e.pressedRight or e.joy == 'right' then
		e.x = e.x + 2
	end
	if e.x > 240 then
		e.x = 240
	end
	if e.x < 16 then
		e.x = 16
	end
	if e.pressedFire and e.fireDelta <= 0 then
		fkge.e('bullet').attr {x = e.x, y = e.y}
		e.fireDelta = 0.4
	end
	if e.fireDelta > 0 then
		e.fireDelta = e.fireDelta - dt
	else
		e.fireDelta = 0
	end
end)

fkge.c('alien', "draw")

fkge.s('alien', function (e, evt)
	if e.x > 240 then
		fkge.fire('alien-walker', 'turn_left')
	end
	if e.x < 16 then
		fkge.fire('alien-walker', 'turn_right')
	end
	local bullets = evt.bullet_launched
	if bullets then
		for _, b in ipairs(bullets) do
			local dx = math.abs(b.x - e.x)
			local dy = math.abs(b.y - e.y)
			local dw = math.abs(b.w - e.w)
			local dh = math.abs(b.h - e.h)
			if dx + dy <= (dw + dh) / 2 then
				e.destroy = true
				b.destroy = true
			end
		end
	end
end)

local function newAlien(name, w, h, c)
	fkge.c(name, "alien", {
		w = w,
		h = h,
		color = c,
	})
	fkge.s(name, function (e, evt, dt)
		if evt.move_right then
			e.x = e.x + 2
		elseif evt.move_left then
			e.x = e.x - 2
		end
	end)
end

newAlien('alien1', 12, 12, {1, 0, 0})
newAlien('alien2', 14, 14, {1, 5/7, 0})
newAlien('alien3', 14, 14, {2/7, 5/7, 0})
newAlien('alien4', 16, 15, {0, 5/7, 1})
newAlien('alien5', 16, 16, {5/7, 0, 1})

fkge.s('draw', function (e)
	lg.push()
	lg.setColor(e.color)
	lg.rectangle('fill', e.x - e.w/2, e.y - e.h/2, e.w, e.h)
	lg.pop()
end)

fkge.c('alien-walker', {
	walkRow = 5,
	headingRight = true,
	nextHeadingRight = true,
	speed = 30,
	tick = 0,
})

fkge.s('alien-walker', function (e, evt)
	if evt.turn_right then
		e.nextHeadingRight = true
	elseif evt.turn_left then
		e.nextHeadingRight = false
	end

	if e.tick > 0 then
		e.tick = e.tick - 1
		return
	end

	if e.headingRight then
		fkge.fire('alien'..e.walkRow, 'move_right')
	else
		fkge.fire('alien'..e.walkRow, 'move_left')
	end
	e.walkRow = e.walkRow - 1
	if e.walkRow < 1 then
		e.walkRow = 5
		e.tick = e.speed
		e.headingRight = e.nextHeadingRight
	else
		e.tick = 5
	end
end)

fkge.s('input', function (e, evt)
	for _, k in ipairs(evt.keypressed or {}) do
		if k == 'left' then
			e.pressedLeft = true
		elseif k == 'right' then
			e.pressedRight = true
		elseif k == 'space' then
			e.pressedFire = true
		end
	end
	for _, k in ipairs(evt.keyreleased or {}) do
		if k == 'escape' then
			fkge.stop()
		elseif k == 'left' then
			e.pressedLeft = false
		elseif k == 'right' then
			e.pressedRight = false
		elseif k == 'space' then
			e.pressedFire = false
		end
	end
	for _, j in ipairs(evt.joystickaxis or {}) do
		if j[2] == 1 then
			if j[3] < -0.5 then
				e.joy = 'left'
			elseif j[3] > 0.5 then
				e.joy = 'right'
			else
				e.joy = 'center'
			end
		end
	end
	for _, j in ipairs(evt.joystickpressed or {}) do
		if j[2] >= 1 and j[2] <= 4 then
			e.pressedFire = true
		end
	end
	for _, j in ipairs(evt.joystickreleased or {}) do
		if j[2] >= 1 and j[2] <= 4 then
			e.pressedFire = false
		end
	end
end)

fkge.c('bullet', "draw", {
	w = 4,
	h = 8,
	color = {1, 1, 1},
})

fkge.s('bullet', function (e, evt)
	e.y = e.y - 4
	if e.y < 0 then
		e.destroy = true
	else
		fkge.fire('alien', 'bullet_launched', e)
	end
end)

fkge.scene('game', function ()
	for j=1, 5 do
		for i=1, 8 do
			fkge.e('alien'..j).attr {
				x = 24 + i*24,
				y = 24 + j*16,
			}
		end
	end
	fkge.e('alien-walker')
	fkge.e('ship').attr {
		x = 128,
		y = 176,
	}
end)

fkge.scene'game'
