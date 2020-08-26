extends projectile

slave var repl_position

func _process(delta):
	if(is_network_master()):
		
		update_move_direction(dir,delta)
		
		userUpdate()
	else:
		
		clientUpdate()

func userUpdate():
	rset("repl_position", position)

func clientUpdate():
	position = repl_position
