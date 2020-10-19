extends KinematicBody2D

const INITIAL_SPEED = 0
const ROTATION_FACTOR = 1.1
const MIN_SPEED_TO_ROTATE = 55
const MAX_FORWARD_SPEED = 220
const MAX_BACKWARDS_SPEED = 110
const FORWARD_ACCELERATION = 4
const BACKWARDS_ACCELERATION = 2
const SLOWING_FACTOR_WHEN_MOVING_FORWARD = 4
const SLOWING_FACTOR_WHEN_MOVING_BACKWARDS = 2
const BOUNCE_FACTOR = 0.5

var speed = INITIAL_SPEED
var velocity: Vector2
var rotation_dir
var collision
var x = 0

var landed = false
var can_land = true
onready var land_start_engines_timer = get_node("LandStartEnginesTimer")

onready var world = get_tree().get_root().get_node("Void")

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
		if (speed < MAX_FORWARD_SPEED):
			speed += FORWARD_ACCELERATION
		if(speed < 0):
			speed += 32 #brakes
		velocity = Vector2(speed, 0).rotated(global_rotation)
	else: speed -= FORWARD_ACCELERATION #don't delete
	
	if Input.is_action_pressed('ui_down'): #backwards
		if (speed > -MAX_BACKWARDS_SPEED):
			speed -= BACKWARDS_ACCELERATION #backwards acceleration
			if(speed > 0):
				speed -= 32 #brakes
		velocity = Vector2(speed, 0).rotated(global_rotation)
	else: speed += FORWARD_ACCELERATION #don't delete
	
	if Input.is_action_pressed('ui_up') == false and Input.is_action_pressed('ui_down') == false: #slowing down after no user input
		if (speed > 0):
			speed -= SLOWING_FACTOR_WHEN_MOVING_FORWARD
		elif (speed < 0):
			speed += SLOWING_FACTOR_WHEN_MOVING_BACKWARDS
			
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit()
	
	if collision: #bounce mechanic
		speed = - speed * BOUNCE_FACTOR
	
	velocity = Vector2(speed, 0).rotated(global_rotation)

func _physics_process(delta):
	if not landed:
		get_input()
		global_rotation += rotation_dir * ROTATION_FACTOR * delta
		collision = move_and_collide(velocity * delta) #registering collisions for bounce mechanic
		$CanvasLayer/Label.text = "Money: " + var2str(money) + "$"
	else:
		if Input.is_action_just_pressed('ui_up'):
			land_start_engines_timer.start()
		if Input.is_action_just_released('ui_up'):
			land_start_engines_timer.stop()


func _on_LandStartEnginesTimer_timeout():
	##TODO make better starting mechanic, add fancy animation, ...
	landed = false
	position += position/5
	reparent(world)

var money=0
var random_money
var passenger_in_taxi=false
var passenger_in_taxi_1=false
var passenger_at_destination_1=false

func _on_Area2D_body_entered(body):
	if passenger_in_taxi_1==false  and passenger_at_destination_1==false and passenger_in_taxi==false:
		passenger_in_taxi_1=true
		passenger_in_taxi=true

func _on_Area2D2_body_entered(body):
	if passenger_in_taxi_1==true:
		passenger_in_taxi_1=false
		passenger_at_destination_1=true
		passenger_in_taxi=false
		money_randomizer()
		money += random_money
		
func money_randomizer():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var current_seed = rng.get_seed()
	random_money = rng.randi_range(100,1000)


func _on_LandDetector_area_entered(area):
	if can_land:
		print("landed!")
		reparent(area)
		landed = true
		can_land = false

func _on_LandDetector_area_exited(area):
	yield(get_tree().create_timer(1), "timeout")
	can_land = true

func reparent(new_parent):
	var global_pos = global_position
	var rot = get_global_rotation()
	get_parent().remove_child(self)
	new_parent.get_parent().add_child(self)
	set_global_position(global_pos)
	set_global_rotation(rot)
