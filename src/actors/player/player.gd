extends character

onready var animationPlayer = $AnimationPlayer
onready var SwordPivot = $SwordPivot
onready var atkCooldown = $AtkCooldown
onready var slashSpawn = $SwordPivot/SlashEffectSpawn
onready var HitBox = $HurtBoxPiv/HurtBox/CollisionShape2D
onready var HurtBoxPivot = $HurtBoxPiv
onready var sprite = $polygons

var animationState = "Idle"

const slashEffect = preload("res://src/scripts/Effects/Slash_effect.tscn")

slave var repl_position = Vector2.ZERO
slave var repl_sword_rotation = 1.0
slave var repl_flip = false
slave var repl_anim_state = "Run"
slave var repl_sword_scale = Vector2.ZERO
slave var repl_slash_Effect_position = Vector2.ZERO
slave var repl_hurt_box_piv = 1.0
slave var hurt_box_on = false


func _ready():

	if(is_network_master()):
		$Camera2D.current = true
		connect("no_health", self, "on_death")

func _process(delta):
	
	if (is_network_master()):
		
		update_move_direction(get_move_dir(), delta)
		
		animation_state()
		
		attack_check()
		# Replicate the position
		userUpdate()
	else:
		# Take replicated variables to set current actor state
		clientUpdate()

func get_move_dir():
	
	var input_vector = Vector2(
	Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	input_vector = input_vector.normalized()
	
	return input_vector

func animation_state():
	
	if velocity != Vector2.ZERO:
		animationState = "Run"
	else:
		animationState = "Idle"
		
	if get_local_mouse_position().x < 0:
		sprite.scale.x = -1
		repl_flip = true
	else:
		sprite.scale.x = 1
		repl_flip = false
	
	
	
	animationPlayer.play(animationState)

func attack_check():
	
	SwordPivot.look_at(get_global_mouse_position())
	HurtBoxPivot.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("ui_fire") && atkCooldown.get_time_left() == 0:
		rpc('_slash')
		HitBox.set_disabled(false)
		
		atkCooldown.set_wait_time(atk_cooldown)
		atkCooldown.start()
		
		SwordPivot.set_scale(Vector2(-1,-1))

func _on_AtkCooldown_timeout():
	atkCooldown.stop()
	SwordPivot.set_scale(Vector2(1,1))
	HitBox.set_disabled(true)

func set_dominant_color(color):
	$polygons.modulate = color

func userUpdate():
	rset("repl_position", position)
	rset("repl_sword_rotation", $SwordPivot.rotation)
	rset("repl_local_mouse_pos", get_local_mouse_position())
	rset("repl_anim_state", animationState)
	rset("repl_sword_scale", SwordPivot.get_scale())
	rset("repl_hurt_box_piv", $HurtBoxPiv.rotation)
	rset("hurt_box_on", $HurtBoxPiv/HurtBox/CollisionShape2D.disabled)

func clientUpdate():
	position = repl_position
	$SwordPivot.rotation = repl_sword_rotation
	
	if repl_flip:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	
	animationPlayer.play(repl_anim_state)
	SwordPivot.set_scale(repl_sword_scale)
	$HurtBoxPiv.rotation = repl_hurt_box_piv
	$HurtBoxPiv/HurtBox/CollisionShape2D.disabled = hurt_box_on

sync func _slash():
	var SlashEffect = slashEffect.instance()
	slashSpawn.add_child(SlashEffect)
	SlashEffect.global_position = slashSpawn.global_position

func on_death():
	queue_free()


