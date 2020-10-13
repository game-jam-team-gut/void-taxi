extends KinematicBody2D

export (int) var speed = 0 #initial speed
export (float) var rotation_speed = 1.1 #rotation factor

var velocity = Vector2()
var rotation_dir #rotation direction

func get_input():
	rotation_dir = 0 #initial rotation direction
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'): #right
		if(speed>55 or speed<-55): #rotation depending on the speed, so you can't turn in place
			rotation_dir += 1 #rotation direction
	if Input.is_action_pressed('ui_left'): #left
		if(speed>75 or speed<-75): #rotation depending on the speed, so you can't turn in place
			rotation_dir -= 1 #rotation direction
	if Input.is_action_pressed('ui_up'): #forward
		if (speed < 440): #maximum speed forward
			speed=speed+4 #forward acceleration
		velocity = Vector2(speed, 0).rotated(rotation)
	else: speed=speed-4 #don't delete
	if Input.is_action_pressed('ui_down'): #backwards
		if (speed > -220): #maximum speed backwards
			speed=speed-2 #backwards acceleration
			if(speed>0):
				speed=speed-32 #brakes
		velocity = Vector2(speed, 0).rotated(rotation)
	else: speed=speed+4 #don't delete
	if InputDefault: #continuous drive at the last registered speed after no user input
		velocity = Vector2(speed, 0).rotated(rotation) 
	if Input.is_action_pressed('ui_up')==false and Input.is_action_pressed('ui_down')==false: #slowing down after no user input
		if (speed > 0):
			speed=speed-4
		elif (speed < 0):
			speed=speed+2

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
