extends AI

onready var projectile_spawner = get_node("projectile_point")
onready var fire_wave = "res://src/actors/AI/fire_spirit/fire_wave.tscn"
onready var sprite = $AnimatedSprite

var dir:Vector2

func _ready():
	connect("target_found", self , "start_timer")
	connect("target_lost", self , "stop_timer")

func _process(delta):
	match state:
		HAS_TARGET:
			dir = targets[0].position - self.position
			sprite.set_flip_h(dir.x > 0)

		IDLE:
			dir = Vector2.ZERO
	
	update_move_direction(dir,delta)

func start_timer():
	$attack_timer.start()

func stop_timer():
	$attack_timer.stop()

func _on_attack_timer_timeout():
		projectile_spawner.spawn_projectile(fire_wave, dir)

