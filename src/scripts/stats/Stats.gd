signal no_health

extends Node

export(int) var ACCEL = 1000
export(int) var FRICTION = 1000
export(int) var MAX_SPEED = 200
export(float) var ATK_COOLDOWN = .1
export(int) var max_health = 1
export(int) var damage = 1
export(int) var knockback_strength = 100
export(int) var knockback_resistance = 50

onready var health = max_health setget update_health

func update_health(value):
	health = value
	if(health <= 0):
		emit_signal("no_health")
