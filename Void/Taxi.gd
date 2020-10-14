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
	else: speed -= FORWARD_ACCELERATION #don't delete
	
	if Input.is_action_pressed('ui_down'): #backwards
		if (speed > -MAX_BACKWARDS_SPEED):
			speed -= BACKWARDS_ACCELERATION #backwards acceleration
			if(speed > 0):
				speed -= 32 #brakes
		velocity = Vector2(speed, 0).rotated(rotation)
	else: speed += FORWARD_ACCELERATION #don't delete
	
	if Input.is_action_pressed('ui_up') == false and Input.is_action_pressed('ui_down') == false: #slowing down after no user input
		if (speed > 0):
			speed -= SLOWING_FACTOR_WHEN_MOVING_FORWARD
		elif (speed < 0):
			speed += SLOWING_FACTOR_WHEN_MOVING_BACKWARDS
	
	if collision: #bounce mechanic
		speed = - speed * BOUNCE_FACTOR
	
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * ROTATION_FACTOR * delta
	collision = move_and_collide(velocity * delta) #registering collisions for bounce mechanic
