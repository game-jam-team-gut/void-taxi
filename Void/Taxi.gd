extends KinematicBody2D

const INITIAL_SPEED = 0
const ROTATION_FACTOR = 1.1
const MIN_SPEED_TO_ROTATE = 55
const MAX_FORWARD_SPEED = 4400
const MAX_BACKWARDS_SPEED = 2200
const FORWARD_ACCELERATION = 4
const BACKWARDS_ACCELERATION = 2
const SLOWING_FACTOR_WHEN_MOVING_FORWARD = 4
const SLOWING_FACTOR_WHEN_MOVING_BACKWARDS = 2
const BOUNCE_FACTOR = 0.5
const DESTRUCTION_FACTOR = 75

var speed = INITIAL_SPEED
var velocity: Vector2
var rotation_dir
var collision
var x = 0
var money = 0
var random_money
var health = 100

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
		velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_action_pressed('ui_down'): #backwards
		if (speed > -MAX_BACKWARDS_SPEED):
			speed -= BACKWARDS_ACCELERATION #backwards acceleration
			if(speed > 0):
				speed -= 32 #brakes
		velocity = Vector2(speed, 0).rotated(rotation)
	
	if Input.is_action_pressed('ui_up') == false and Input.is_action_pressed('ui_down') == false: #slowing down after no user input
		if (speed > 0):
			speed -= SLOWING_FACTOR_WHEN_MOVING_FORWARD
		elif (speed < 0):
			speed += SLOWING_FACTOR_WHEN_MOVING_BACKWARDS
	
	if Input.is_action_pressed('ui_cancel'):
		get_tree().quit()
	
	if collision: #bounce mechanic
		if(speed>33):
			health=int(health-speed/DESTRUCTION_FACTOR)
		if(speed<-33):
			health=int(health+speed/DESTRUCTION_FACTOR)
		speed = int(-speed * BOUNCE_FACTOR)
	
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * ROTATION_FACTOR * delta
	collision = move_and_collide(velocity * delta) #registering collisions for bounce mechanic
	$CanvasLayer/VBoxContainer/Health.text = "Health: " + var2str(health) + " HP" #current health
	$CanvasLayer/VBoxContainer/Money.text = "Money: " + var2str(money) + " $" #current money
	if(speed > 0): #current speed
		$CanvasLayer/VBoxContainer/Speed.text = "Speed: " + var2str(speed) + " footballfields/s"
	if(speed < 0): #current speed
		$CanvasLayer/VBoxContainer/Speed.text = "Speed: " + var2str(-speed) + " footballfields/s"
	if(health<=0): #game over
		get_tree().change_scene("res://MainMenu.tscn")

func money_randomizer():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	random_money = rng.randi_range(100,1000)

#From this line starts the passenger system prototype
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
