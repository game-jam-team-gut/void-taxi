extends KinematicBody2D

signal passenger_pickup(planet)
signal passenger_delivered(planet)

const INITIAL_SPEED = 0
const ROTATION_FACTOR = 1.2
const MIN_SPEED_TO_ROTATE = 100
const MAX_FORWARD_SPEED = 4400
const MAX_BACKWARDS_SPEED = 2200
const FORWARD_ACCELERATION_WEIGHT = 0.004
const BACKWARDS_ACCELERATION_WEIGHT = 0.0031
const SLOW_WEIGHT_WHEN_MOVING_FORWARD = 0.003
const SLOW_WEIGHT_WHEN_MOVING_BACKWARDS = 0.003
const BOUNCE_FACTOR = 0.5
const DESTRUCTION_FACTOR = 75

var speed = INITIAL_SPEED

var velocity: Vector2
var rotation_dir
var collision

var money = 0
var health = 100

onready var timer=get_node("Timer")
var day = 0

onready var collision_raycast_forward = get_node("RayCast2DForward")
onready var collision_raycast_backwards = get_node("RayCast2DBackwards")

func get_input():
	rotation_dir = 0 #initial rotation direction
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed('ui_right'): #right
		if(abs(speed) > MIN_SPEED_TO_ROTATE): #rotation is depending on the speed, so you can't turn in place
			rotation_dir += 1
	
	if Input.is_action_pressed('ui_left'): #left
		if(abs(speed) > MIN_SPEED_TO_ROTATE): #rotation is depending on the speed, so you can't turn in place
			rotation_dir -= 1 
	
	if Input.is_action_pressed('ui_up'): #forward
		if not collision_raycast_forward.is_colliding():
			speed = int(lerp(speed, MAX_FORWARD_SPEED, FORWARD_ACCELERATION_WEIGHT))
			velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_action_pressed('ui_down'): #backwards
		if not collision_raycast_backwards.is_colliding():
			speed = int(lerp(speed, -MAX_BACKWARDS_SPEED, BACKWARDS_ACCELERATION_WEIGHT))
			velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_action_pressed('ui_up') == false and Input.is_action_pressed('ui_down') == false: #slowing down after no user input
		if (speed > 0):
			speed = int(lerp(speed, 0, SLOW_WEIGHT_WHEN_MOVING_FORWARD))
		elif (speed < 0):
			speed = int(lerp(speed, 0, SLOW_WEIGHT_WHEN_MOVING_BACKWARDS))
	
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit()
	
	if collision: #bounce mechanic
		if abs(speed) > 50:
			health=int(health-abs(speed)/DESTRUCTION_FACTOR)
		if abs(speed) > 30:
			speed = int(-speed * BOUNCE_FACTOR)
	
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	check_health()
	get_input()
	taxi_UI()
	rotation += rotation_dir * ROTATION_FACTOR * delta
	collision = move_and_collide(velocity * delta) #registering collisions for bounce mechanic

func _ready(): #setting the timer time to 600 seconds (10 minutes) and starting the timer, calling a timeout when it ends
	timer.set_wait_time(600)
	timer.start()
	_on_Timer_timeout()

func check_health():
	if(health<=0): #game over
		get_tree().change_scene("res://MainMenu.tscn")

func taxi_UI():
	$CanvasLayer/HBoxContainer/VBoxContainer/Health.text = "Health: " + var2str(health) + " HP" #current health
	$CanvasLayer/HBoxContainer/VBoxContainer/Day.text = "Day: #" + var2str(day) #current day
	$CanvasLayer/HBoxContainer/VBoxContainer/Money.text = "Money: " + var2str(money) + " $" #current money
	if collision_raycast_forward.is_colliding() || collision_raycast_backwards.is_colliding():
		$CanvasLayer/HBoxContainer2/VBoxContainer2/Speed.text = "Speed: 0 footballfields/s"
	else:
		$CanvasLayer/HBoxContainer2/VBoxContainer2/Speed.text = "Speed: " + var2str(abs(speed)) + " footballfields/s"

func emit_pickup_signal(planet):
	emit_signal("passenger_pickup", planet)

func emit_passenger_delivered_signal(planet):
	emit_signal("passenger_delivered", planet)

func _on_Timer_timeout():
	day+=1
