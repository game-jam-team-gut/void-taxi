extends Node

const DAY_LENGTH = 515 #515 for 7 days in 1 hour

var day = 0

onready var timer=get_node("Timer")
onready var daycycle_label = get_node("../CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer/Day")
onready var daysummary_label = get_node("../CanvasLayer/HBoxContainer3/VBoxContainer3/NewDay")
onready var rent_label = get_node("../CanvasLayer/HBoxContainer/VBoxContainer/HBoxContainer3/Rent")

func _ready():
	timer.set_wait_time(DAY_LENGTH) #setting the timer time
	timer.start() #starting the timer
	_on_Timer_timeout() #calling a timeout when it ends

func _on_Timer_timeout():
	day+=1

func update_daycycle_UI():
	daycycle_label.text = "Stellar day: #" + var2str(day)

func update_daysummary_UI():
	if day>1:
		daysummary_label.text = "New day has come!"
		rent_label.text = " -1000$"

func _process(delta):
	update_daycycle_UI()
	update_daysummary_UI()
