extends Node


var max_number_of_passengers = 4
var current_passengers = 0

onready var passengers_label = get_node("../CanvasLayer/VBoxContainer/Passengers")

func _ready():
	update_passenger_UI()

func update_passenger_UI():
	passengers_label.text = "Passengers: " + str(current_passengers) + "/" + str(max_number_of_passengers)

func _on_PassengerDetector_area_entered(area):
	if area.is_in_group("PickupPoint"):
		var available_passengers = area.get_available_passengers()
		if available_passengers <= max_number_of_passengers: #or check if current passengers + available <= max if we want to have multiple passengers
			current_passengers += available_passengers
			update_passenger_UI()
			get_parent().emit_pickup_signal(area.get_parent())
			area.queue_free()
	elif area.is_in_group("Destination"):
		current_passengers = 0
		update_passenger_UI()
		get_parent().money += 100 #change hopefully to something different, maybe based on time, maybe on passenger type, idk
		get_parent().emit_passenger_delivered_signal()
		area.queue_free()
