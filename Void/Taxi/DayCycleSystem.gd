extends Node

const DAY_LENGTH = 60 #new day every 1 minute

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
	if day > 7:
		get_tree().change_scene("res://WinCredits.tscn")

func update_daycycle_UI():
	daycycle_label.text = "Stellar day: #" + var2str(day)

func update_daysummary_UI():
	if day>1:
		daysummary_label.text = "New day has come!"
		rent_label.text = " -" + var2str(get_parent().RENT)

func _process(delta):
	update_daycycle_UI()
	update_daysummary_UI()
