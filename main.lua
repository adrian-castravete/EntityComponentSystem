fkge = require'fkge'
e = fkge.ecs

fkge.game {
  width = 256,
  height = 192,
}

e.scene('game', function()
end)

e.scene('load', function()
  fkge.scene'game'
end)

e.scene'load'