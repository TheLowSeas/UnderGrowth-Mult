extends AI

onready var projectile_spawner = $projectile_spawner

var dir:Vector2
var fire_wave = "res://src/scripts/projectiles/projectile.tscn"


slave var repl_position:Vector2

func _ready():
	
	connect("no_health", self,"on_death")
	connect("target_found", self , "start_timer")
	connect("target_lost", self , "stop_timer")
	
	$attack_timer.set_wait_time(atk_cooldown)

func _process(delta):
	if(is_network_master()):
		match state:
			HAS_TARGET:
				if targets[0] != null:
					dir = targets[0].global_position - self.global_position
					$scare_crow.set_flip_h(dir.x > 0)
			IDLE:
				dir = Vector2.ZERO
		
		userUpdate()
	else:
		
		clientUpdate()

func userUpdate():
	rset("repl_position", position)


func clientUpdate():
	position = repl_position

func on_death():
	queue_free()

func start_timer():
	$attack_timer.start()

func stop_timer():
	$attack_timer.stop()

func _on_attack_timer_timeout():
		projectile_spawner.spawn_projectile(fire_wave, dir,0,0)
