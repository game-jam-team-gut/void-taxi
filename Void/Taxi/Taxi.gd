extends KinematicBody2D

signal passenger_pickup(planet)
signal passenger_delivered(planet)

const INITIAL_SPEED = 0
const ROTATION_FACTOR = 1.2
const MIN_SPEED_TO_ROTATE = 100
const MAX_FORWARD_SPEED = 4400
const MAX_TURNING_SPEED = 2200
const MAX_BACKWARDS_SPEED = 2200
const FORWARD_ACCELERATION_WEIGHT = 0.004
const BACKWARDS_ACCELERATION_WEIGHT = 0.0031
const SLOW_WEIGHT_WHEN_MOVING_FORWARD = 0.003
const SLOW_WEIGHT_WHEN_MOVING_BACKWARDS = 0.003
const BOUNCE_FACTOR = 0.5
const DESTRUCTION_FACTOR = 75
const RENT = 2000

var speed = INITIAL_SPEED

var velocity: Vector2
var rotation_dir
var collision

var money = 0
var health = 200

var taxi_body_broken = preload("res://Void/Taxi/taxi_body_broken.png")

onready var arrow = get_node("Arrow/arrow")
onready var arrows_to_pickups_manager = get_node("ArrowToPickupPointsManager")

onready var collision_raycast_forward1 = get_node("RayCast2DForward")
onready var collision_raycast_forward2 = get_node("RayCast2DForward2")
onready var collision_raycast_forward3= get_node("RayCast2DForward3")
onready var collision_raycast_backwards1 = get_node("RayCast2DBackwards")
onready var collision_raycast_backwards2 = get_node("RayCast2DBackwards2")
onready var collision_raycast_backwards3 = get_node("RayCast2DBackwards3")
onready var engine_particles_back_left = get_node("Sprite/taxi_engine_left/EngineParticles2D")
onready var engine_particles_back_right = get_node("Sprite/taxi_engine_right/EngineParticles2D")
onready var engine_particles_front_left = get_node("Sprite/taxi_engine_forward_left/EngineParticles2D")
onready var engine_particles_front_right = get_node("Sprite/taxi_engine_forward_right/EngineParticles2D")

func get_input():
	var engine_front_left = false
	var engine_front_right  = false
	var engine_back_left  = false
	var engine_back_right = false
	
	rotation_dir = 0 #initial rotation direction
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed('ui_right'): #right
		if(abs(speed) > MIN_SPEED_TO_ROTATE): #rotation is depending on the speed, so you can't turn in place
			rotation_dir += 1
			if speed > 0:
				engine_back_left = true
			else:
				engine_front_left = true
	
	if Input.is_action_pressed('ui_left'): #left
		if(abs(speed) > MIN_SPEED_TO_ROTATE): #rotation is depending on the speed, so you can't turn in place
			rotation_dir -= 1 
			if speed > 0:
				engine_back_right = true
			else:
				engine_front_right = true
	
	if Input.is_action_pressed('ui_up'): #forward
		if not collision_raycast_forward1.is_colliding():
			if rotation_dir == 0:
				speed = int(lerp(speed, MAX_FORWARD_SPEED, FORWARD_ACCELERATION_WEIGHT))
			else:
				speed = int(lerp(speed, MAX_TURNING_SPEED, FORWARD_ACCELERATION_WEIGHT))
			velocity = Vector2(speed, 0).rotated(rotation)
			if not(engine_back_left || engine_back_right):
				engine_back_left = true
				engine_back_right = true
	elif rotation_dir == 0:
		engine_back_left = false
		engine_back_right = false
	
	if Input.is_action_pressed('ui_down'): #backwards
		if not collision_raycast_backwards1.is_colliding():
			speed = int(lerp(speed, -MAX_BACKWARDS_SPEED, BACKWARDS_ACCELERATION_WEIGHT))
			velocity = Vector2(speed, 0).rotated(rotation)
			if not(engine_front_left || engine_front_right):
				engine_front_left = true
				engine_front_right = true
	elif rotation_dir == 0:
		engine_front_left = false
		engine_front_right = false
	
	if Input.is_action_pressed('ui_up') == false and Input.is_action_pressed('ui_down') == false: #slowing down after no user input
		if (speed > 0):
			speed = int(lerp(speed, 0, SLOW_WEIGHT_WHEN_MOVING_FORWARD))
		elif (speed < 0):
			speed = int(lerp(speed, 0, SLOW_WEIGHT_WHEN_MOVING_BACKWARDS))
	
	if Input.is_action_pressed('ui_cancel'):
		get_tree().change_scene("res://MainMenu.tscn")
	
	check_collisions()
	
	velocity = Vector2(speed, 0).rotated(rotation)
	
	#set_engine_sound
	if engine_front_left || engine_front_right || engine_back_left || engine_back_right:
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
	
	#set engine particles
	engine_particles_front_left.set_emitting(engine_front_left)
	engine_particles_front_right.set_emitting(engine_front_right)
	engine_particles_back_left.set_emitting(engine_back_left)
	engine_particles_back_right.set_emitting(engine_back_right)

func check_collisions():
	if collision: #bounce mechanic
		collide_with_object()
	check_raycast_asteroid_collision(collision_raycast_backwards1)
	check_raycast_asteroid_collision(collision_raycast_backwards2)
	check_raycast_asteroid_collision(collision_raycast_backwards3)
	check_raycast_asteroid_collision(collision_raycast_forward1)
	check_raycast_asteroid_collision(collision_raycast_forward2)
	check_raycast_asteroid_collision(collision_raycast_forward3)

func check_raycast_asteroid_collision(raycast):
	if raycast.is_colliding():
		if raycast.get_collider().is_in_group("Asteroid"):
			collide_with_object()

func collide_with_object():
	if abs(speed) > 50:
		take_damage(int(abs(speed)/DESTRUCTION_FACTOR))
	if abs(speed) > 30:
		speed = int(-speed * BOUNCE_FACTOR)

func _physics_process(delta):
	get_input()
	taxi_UI()
	rotation += rotation_dir * ROTATION_FACTOR * delta
	collision = move_and_collide(velocity * delta) #registering collisions for bounce mechanic

func take_damage(damage):
	health -= damage
	if(health <= 100):
		get_node("Sprite").set_texture(taxi_body_broken)
	if(health <= 0): #game over
		get_tree().change_scene("res://GameOver.tscn")

func taxi_UI():
	$CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer2/Health.text = "Health: " + var2str(health) + " HP" #current health
	$CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer3/Money.text = "Money: " + var2str(money) + " $" #current money
	if collision_raycast_forward1.is_colliding() || collision_raycast_backwards1.is_colliding():
		$CanvasLayer/HBoxContainer2/VBoxContainer2/Speed.text = "Speed: 0 kps"
	else:
		$CanvasLayer/HBoxContainer2/VBoxContainer2/Speed.text = "Speed: " + var2str(abs(speed)) + " kps"

func emit_pickup_signal(planet):
	emit_signal("passenger_pickup", planet)

func emit_passenger_delivered_signal(planet):
	emit_signal("passenger_delivered", planet)

func _on_Timer_timeout():
	money-=RENT
	if money < 0: #game over
		get_tree().change_scene("res://GameOver.tscn")


func _on_PassengersDestinationsAssigner_destination_set(destination):
	arrow.set_destination(destination)
	arrows_to_pickups_manager.set_arrows_visibility(false)


func _on_PassengersDestinationsAssigner_new_pickup_point(pickup_point):
	yield(get_tree().create_timer(.1), "timeout")
	arrows_to_pickups_manager.on_new_pickup_point_created(pickup_point)
