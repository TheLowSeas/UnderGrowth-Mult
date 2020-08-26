extends character
class_name AI

enum {
	IDLE,
	HAS_TARGET,
}

signal target_found
signal target_lost

onready var vision = get_node("PlayerDetectionZone")
var targets = []
onready var state = IDLE


func _ready():
	$vision.connect("body_entered", self , "add_target")
	$vision.connect("body_exited", self , "remove_target")


func add_target(_target:PhysicsBody2D):
	targets.append(_target)
	
	emit_signal("target_found")
	state = HAS_TARGET

func remove_target(_target:PhysicsBody2D):
	targets.erase(_target)
	
	if targets.size() == 0:
		emit_signal("target_lost")
		state = IDLE
