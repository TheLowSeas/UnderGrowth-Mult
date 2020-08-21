extends KinematicBody2D
class_name movement_controller

export var max_speed = 200
export var friction = 500
export var acceleration = 500
var velocity = Vector2.ZERO


func update_move_direction(dir:Vector2 , delta: float):
	dir = dir.normalized()
	
	if(dir  == Vector2.ZERO):
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
	else:
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	
	
	velocity = move_and_slide(velocity)
