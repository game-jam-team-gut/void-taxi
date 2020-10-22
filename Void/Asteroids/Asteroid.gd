extends RigidBody2D


func _ready():
	#start rotation_speed
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var trq = rng.randf_range(-800, 800)
	set_applied_torque(trq)
	
	#start_move_speed
	rng.randomize()
	var x = rng.randf_range(-100, 100)
	rng.randomize()
	var y = rng.randf_range(-100, 100)
	set_applied_force(Vector2(x, y)) 
	
	#scale
	rng.randomize()
	var scl = rng.randf_range(0.5, 1.5)
	$Sprite.scale *= scl
	$CollisionPolygon2D.scale *= scl
