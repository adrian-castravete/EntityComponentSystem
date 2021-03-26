fkge = require'fkge'
e = fkge.ecs

fkge.game {
  width = 256,
  height = 192,
}

e.scene('game', function() {
})

e.scene('load', function() {
  fkge.scene'game'
})

e.scene'load'