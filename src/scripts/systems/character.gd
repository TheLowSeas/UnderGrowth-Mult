extends movement_controller
class_name character

export(float) var atk_cooldown = .3
export(int) var max_health = 1
export(int) var damage = 1
export(int) var knockback_strength = 100
export(int) var knockback_resistance = 50

var knockback_vector = Vector2.ZERO

onready var health = max_health

signal no_health
signal health_change

func _ready():
	$HitBox.connect("area_entered", self, "on_hit")

func _physics_process(delta):
	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, friction * delta)
	knockback_vector = move_and_slide(knockback_vector)

func update_health(damage):
	health -= damage
	emit_signal("health_change")
	if(health <= 0):
		emit_signal("no_health")


func deal_damage():
	
	return damage

func recieve_knockback(area):
	var knockback_dir = position - area.get_owner().get_owner().position
	knockback_dir = knockback_dir.normalized()
	knockback_vector = knockback_dir * (area.get_owner().get_owner().knockback_strength - knockback_resistance)

func on_hit(area):
	update_health(area.get_owner().get_owner().deal_damage())
	recieve_knockback(area)


