extends character

onready var animatonPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var SwordPivot = $SwordPivot
onready var atkCooldown = $AtkCooldown
onready var slashSpawn = $SwordPivot/SlashEffectSpawn
onready var HitBox = $HurtBoxPiv/HurtBox/CollisionShape2D
onready var HurtBoxPivot = $HurtBoxPiv

const slashEffect = preload("res://src/scripts/Effects/Slash_effect.tscn")

slave var repl_position = Vector2.ZERO
slave var repl_sword_rotation = 1.0
slave var repl_local_mouse_pos = Vector2.ZERO
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
		animationTree.set("parameters/Run/blend_position", get_local_mouse_position())
		animationState.travel("Run")
	else:
		animationTree.set("parameters/Idle/blend_position", get_local_mouse_position())
		animationState.travel("Idle")
	

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
	$Chops_Sheet.modulate = color

func userUpdate():
	rset("repl_position", position)
	rset("repl_sword_rotation", $SwordPivot.rotation)
	rset("repl_local_mouse_pos", get_local_mouse_position())
	rset("repl_anim_state", animationState.get_current_node())
	rset("repl_sword_scale", SwordPivot.get_scale())
	rset("repl_hurt_box_piv", $HurtBoxPiv.rotation)
	rset("hurt_box_on", $HurtBoxPiv/HurtBox/CollisionShape2D.disabled)

func clientUpdate():
	position = repl_position
	$SwordPivot.rotation = repl_sword_rotation
	animationTree.set("parameters/Idle/blend_position", repl_local_mouse_pos)
	animationTree.set("parameters/Run/blend_position", repl_local_mouse_pos)
	animationState.travel(repl_anim_state)
	SwordPivot.set_scale(repl_sword_scale)
	$HurtBoxPiv.rotation = repl_hurt_box_piv
	$HurtBoxPiv/HurtBox/CollisionShape2D.disabled = hurt_box_on

sync func _slash():
	var SlashEffect = slashEffect.instance()
	slashSpawn.add_child(SlashEffect)
	SlashEffect.global_position = slashSpawn.global_position

func on_death():
	queue_free()


