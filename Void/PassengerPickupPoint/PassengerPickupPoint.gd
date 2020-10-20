extends Area2D

var available_passengers setget ,get_available_passengers

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	available_passengers = rng.randi_range(1, 3)

func get_available_passengers():
	return available_passengers

