extends AI

var dir:Vector2

slave var repl_position:Vector2

func _ready():
	connect("no_health", self,"on_death")

func _process(delta):
	if(is_network_master()):
		match state:
			HAS_TARGET:
				if targets[0] != null:
					dir = targets[0].position - self.position
					$AnimatedSprite.set_flip_h(dir.x > 0)
			IDLE:
				dir = Vector2.ZERO
		
		update_move_direction(dir,delta)
		
		userUpdate()
	else:
		
		clientUpdate()

func userUpdate():
	rset("repl_position", position)


func clientUpdate():
	position = repl_position

func on_death():
	queue_free()
