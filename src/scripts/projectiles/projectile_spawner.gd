extends Node
class_name projectile_spawner


func spawn_projectile(projectile_directory, dir:Vector2, x , y):
	#var projectileScene:projectile = load(projectile_directory)
	var projectile= load(projectile_directory).instance()
	get_tree().get_root().add_child(projectile)

	projectile.dir = dir
	projectile.rotation = dir.angle()
	var pos:Vector2
	pos.x = self.global_position.x + x
	pos.y = self.global_position.y + y
	projectile.set_position(pos)
