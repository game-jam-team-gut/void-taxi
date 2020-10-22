extends Node

onready var timer=get_node("Timer")
onready var daycycle_label = get_node("../CanvasLayer/HBoxContainer/VBoxContainer/Day")
var day = 0

func _ready(): #setting the timer time to 515 seconds (~7 days in 1 hour) and starting the timer, calling a timeout when it ends
	timer.set_wait_time(515)
	timer.start()
	_on_Timer_timeout()

func _on_Timer_timeout():
	day+=1

func update_daycycle_UI():
	daycycle_label.text = "Stellar day: #" + var2str(day)

func _process(delta):
	update_daycycle_UI()
