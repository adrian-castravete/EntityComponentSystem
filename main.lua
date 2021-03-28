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

fkge.c('ship', "draw", {
	w = 16,
	h = 16,
})

fkge.c('alien', "draw", {
})

fkge.c('alien1', "alien", {
	w = 12,
	h = 12,
	color = {1, 0, 0},
})

fkge.c('alien2', "alien", {
	w = 14,
	h = 14,
	color = {1, 5/7, 0},
})

fkge.c('alien3', "alien", {
	w = 14,
	h = 14,
	color = {2/7, 5/7, 0},
})

fkge.c('alien4', "alien", {
	w = 16,
	h = 16,
	color = {0, 5/7, 1},
})

fkge.c('alien5', "alien", {
	w = 16,
	h = 16,
	color = {5/7, 0, 1},
})

fkge.c('alien-walker', {
	walkRow = 5,
	headingRight = true,
	nextHeadingRight = true,
	speed = 30,
	tick = 0,
})

fkge.s('draw', function (e)
	lg.push()
	lg.setColor(e.color)
	lg.translate(128, 96)
	lg.rectangle('fill', e.x - e.w/2, e.y - e.h/2, e.w, e.h)
	lg.pop()
end)

fkge.s('alien-walker', function (e)
	if e.tick > 0 then
		e.tick = e.tick - 1
		return
	end

	--if e.headingRight then
	--	fkge.fire('alien'..e.walkRow..'-move-right')
	--else
	--	fkge.fire('alien'..e.walkRow..'-move-left')
	--end
	e.walkRow = e.walkRow - 1
end)

fkge.scene('game', function()
	for j=1, 5 do
		for i=1, 8 do
			fkge.e('alien'..j).attr {
				x = 36 + i*24,
				y = 36 + j*16,
			}
		end
	end
	fkge.e('alien-walker')
end)

fkge.scene'game'
