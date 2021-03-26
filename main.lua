fkge = require'fkge'
e = fkge.ecs

fkge.game {
	width = 256,
	height = 192,
}

e.scene('game', function()
	e.c('ship', {
		req = {'graphics', 'input'},
	})
end)

e.scene('load', function()
	e.scene'game'
end)

e.scene'load'
