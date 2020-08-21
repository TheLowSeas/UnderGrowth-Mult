extends Control

signal healthbar_update

func _ready():
	pass

func update_healthbar(health):
	emit_signal("healthbar_update")
