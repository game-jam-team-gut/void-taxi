extends KinematicBody2D

export (int) var speed = 200
var velocity = Vector2()
var movement = 0

onready var timer=get_node("Timer")

func _ready():
	velocity = velocity.normalized() * speed
	timer.set_wait_time(1) #setting the timer time
	timer.start() #starting the timer
	_on_Timer_timeout() #calling a timeout when it ends

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if(movement>1 and movement <15):
		velocity.y=-80
	elif(movement>1):
		velocity.y=0
		timer.stop()

func _on_Timer_timeout():
	movement+=1
