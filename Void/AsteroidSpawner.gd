extends Node

var MAX_ASTEROID_COUNT = 200
var MAX_ASTEROID_DISTANCE = 200000

onready var asteroid1 = preload("res://Void/Asteroids/Asteroid1.tscn")
onready var asteroid2 = preload("res://Void/Asteroids/Asteroid2.tscn")
onready var asteroid3 = preload("res://Void/Asteroids/Asteroid3.tscn")
onready var asteroid4 = preload("res://Void/Asteroids/Asteroid4.tscn")
onready var asteroid5 = preload("res://Void/Asteroids/Asteroid5.tscn")

onready var minimap_camera = get_node("/root/Main/MinimapViewportContainer/Viewport/Camera2D")

onready var sun_system_center = get_node("../PlanetSystem").position

var minimum_asteroid_distance: Vector2
var current_asteroids = []
var current_max_asteroid_count
var asteroids_initial_aims = []



func _ready():
	current_max_asteroid_count = 100
	minimum_asteroid_distance = Vector2(1920 * 4, 1080 * 4)
	asteroids_initial_aims = get_tree().get_nodes_in_group("Asteroid_aims")
	asteroids_initial_aims = asteroids_initial_aims +  get_tree().get_nodes_in_group("Planet")
	asteroids_initial_aims.append(get_node("../Taxi"))
	asteroids_initial_aims.append(get_node("../PlanetSystem"))
	yield(get_tree().create_timer(.1), "timeout")
	generate_starting_asteroids()

func generate_starting_asteroids():
	while len(current_asteroids) < current_max_asteroid_count:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		var asteroid_to_instance
		match rng.randi_range(1,5):
			1:
				asteroid_to_instance = asteroid1
			2:
				asteroid_to_instance = asteroid2
			3:
				asteroid_to_instance = asteroid3
			4:
				asteroid_to_instance = asteroid4
			5:
				asteroid_to_instance = asteroid5
		
		var asteroid_instance = asteroid_to_instance.instance()
		get_parent().add_child(asteroid_instance)
		
		rng.randomize()
		var y_delta = rng.randf_range(-1,1)
		rng.randomize()
		var x_delta = rng.randf_range(-1,1)
		asteroid_instance.position = Vector2(sun_system_center.x + MAX_ASTEROID_DISTANCE/10 * x_delta, 
											sun_system_center.y + MAX_ASTEROID_DISTANCE/10 * y_delta)
		
		rng.randomize()
		var initial_force = rng.randf_range(0,150)
		
		rng.randomize()
		var initial_aim =  asteroids_initial_aims[rng.randi_range(0, len(asteroids_initial_aims) - 1)].position
		
		asteroid_instance.set_initial_force((initial_aim - asteroid_instance.position).normalized() * initial_force)
		
		current_asteroids.append(asteroid_instance)

func _on_SpawnTimer_timeout():
	if len(current_asteroids) < current_max_asteroid_count:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		var asteroid_to_instance
		match rng.randi_range(1,5):
			1:
				asteroid_to_instance = asteroid1
			2:
				asteroid_to_instance = asteroid2
			3:
				asteroid_to_instance = asteroid3
			4:
				asteroid_to_instance = asteroid4
			5:
				asteroid_to_instance = asteroid5
		
		var asteroid_instance = asteroid_to_instance.instance()
		get_parent().add_child(asteroid_instance)
		
		var screen_center_in_world = minimap_camera.get_camera_position()
		
		rng.randomize()
		match rng.randi_range(1,4):
			1: #left
				rng.randomize()
				var y_delta = rng.randf_range(-1,1)
				asteroid_instance.position = Vector2(screen_center_in_world.x - MAX_ASTEROID_DISTANCE, 
													screen_center_in_world.y + MAX_ASTEROID_DISTANCE * y_delta)
			2: #up
				rng.randomize()
				var y_delta = rng.randf_range(-1,1)
				asteroid_instance.position = Vector2(screen_center_in_world.x + MAX_ASTEROID_DISTANCE * y_delta, 
													screen_center_in_world.y - MAX_ASTEROID_DISTANCE )
			3: #down
				rng.randomize()
				var y_delta = rng.randf_range(-1,1)
				asteroid_instance.position = Vector2(screen_center_in_world.x + MAX_ASTEROID_DISTANCE * y_delta, 
													screen_center_in_world.y + MAX_ASTEROID_DISTANCE )
			4: #right
				rng.randomize()
				var y_delta = rng.randf_range(-1,1)
				asteroid_instance.position = Vector2(screen_center_in_world.x + MAX_ASTEROID_DISTANCE, 
													screen_center_in_world.y + MAX_ASTEROID_DISTANCE * y_delta)
		
		rng.randomize()
		var initial_force = rng.randf_range(0,100 + 100 * (float(current_max_asteroid_count)/float(MAX_ASTEROID_COUNT)))
		
		rng.randomize()
		var initial_aim =  asteroids_initial_aims[rng.randi_range(0, len(asteroids_initial_aims) - 1)].position
		
		asteroid_instance.set_initial_force((initial_aim - asteroid_instance.position).normalized() * initial_force)
		
		current_asteroids.append(asteroid_instance)

func _on_AsteroidCountIncrease_timeout():
	if current_max_asteroid_count < MAX_ASTEROID_COUNT:
		current_max_asteroid_count += 1
	for asteroid in current_asteroids:
		if asteroid != null:
			if asteroid.position.distance_to(sun_system_center) > MAX_ASTEROID_DISTANCE:
				asteroid.queue_free()
		else:
			current_asteroids.erase(asteroid)
