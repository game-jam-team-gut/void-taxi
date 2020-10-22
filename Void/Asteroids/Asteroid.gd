extends RigidBody2D


func _ready():
	#start rotation_speed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var trq = rng.randf_range(-800, 800)
	set_applied_torque(trq)
	
	#scale
	rng.randomize()
	var scl = rng.randf_range(0.5, 1.5)
	$Sprite.scale *= scl
	$CollisionPolygon2D.scale *= scl

func set_initial_force(force):
	set_applied_force(force) 


func _on_Asteroid_body_entered(body):
	if body.is_in_group("BurningZone3"):
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
