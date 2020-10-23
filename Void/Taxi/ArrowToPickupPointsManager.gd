extends Node

onready var arrow = preload("res://Void/Taxi/arrow.tscn")

var points = []
var MAX_ARROW_COUNT = 3
var current_arrows = []
var current_arrows_visibility = true


func _ready():
	pass

func set_arrows_visibility(are_visible):
	current_arrows_visibility = are_visible
	for arrow in current_arrows:
		if are_visible:
			arrow.should_be_hidden = false
		else:
			arrow.should_be_hidden = true

func on_new_pickup_point_created(pickup_point):
	points.append(pickup_point)
	update_arrows_count_and_destinations()

func update_arrows_count_and_destinations():
	if len(current_arrows) < MAX_ARROW_COUNT:
		var arrow_instance = arrow.instance()
		get_node("../Arrow").add_child(arrow_instance)
		arrow_instance.set_destination(points[-1])
		current_arrows.append(arrow_instance)
		if current_arrows_visibility:
			arrow_instance.should_be_hidden = false
		else:
			arrow_instance.should_be_hidden = true

func got_passenger(pickup_point):
	clean_unnecesary_arrows(pickup_point)

func clean_unnecesary_arrows(pickup_point):
	for arrow in current_arrows:
		if arrow.destination == pickup_point || arrow.destination == null:
			arrow.queue_free()
			current_arrows.erase(arrow)

func _on_ArrowCleanTimer_timeout():
	#clean_unnecesary_arrows(null)
	if len(points) > 3:
		for point in points:
			if point == null:
				points.erase(point)
		points.sort_custom(MyCustomSorter, "custom_sort")
		var i = len(points) - 1
		for arrow in current_arrows:
			arrow.destination = points[i]
			i-=1

class MyCustomSorter:
	static func custom_sort(a, b):
		return a.position.distance_to(a.player.position) < b.position.distance_to(b.player.position)
