extends movement_controller
class_name projectile

export(int) var damage = 1
export(int) var knockback_strength = 100
var dir:Vector2 


func deal_damage():
	return damage
