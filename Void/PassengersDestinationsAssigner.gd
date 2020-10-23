extends Node

signal destination_set(destination)
signal new_pickup_point(pickup_point)

var MAX_PICKUP_POINTS_NUMBER = 8

var current_pickup_points = []
var current_destination = null

var planets

onready var passenger_pickup_object = preload("res://Void/PassengerPickupPoint.tscn")
onready var destination_object = preload("res://Void/DestinationPoint.tscn")

func _ready():
	planets = get_tree().get_nodes_in_group("Planet")
	create_passenger_pickup_point(null) #first passenger

func _process(delta):
	if Input.is_key_pressed(KEY_P):
		create_passenger_pickup_point(null)

func create_passenger_pickup_point(excluded_planet):
	var passenger_pickup_point_instance = passenger_pickup_object.instance()
	if excluded_planet:
		var excluded_planet_r = calculate_approximately_planet_radius(excluded_planet)
		if excluded_planet_r > 150:
			excluded_planet = null
	var planet = get_random_planet(excluded_planet)
	planet.add_child(passenger_pickup_point_instance)
	var r = calculate_approximately_planet_radius(planet)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-r, r)
	rng.randomize()
	var y = rng.randf_range(-r, r)
	passenger_pickup_point_instance.position = Vector2(x, y)
	passenger_pickup_point_instance.set_global_rotation(0)
	current_pickup_points.append(passenger_pickup_point_instance)
	emit_signal("new_pickup_point", passenger_pickup_point_instance)


func create_destination(excluded_planets):
	var destination_instance = destination_object.instance()
	var planet = get_random_planet(excluded_planets)
	planet.add_child(destination_instance)
	var planet_size = planet.get_node("Sprite").texture.get_size()
	var r = sqrt(pow(planet_size.x,2) + pow(planet_size.y,2))/5
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-r, r)
	rng.randomize()
	var y = rng.randf_range(-r, r)
	destination_instance.position = Vector2(x, y)
	destination_instance.set_global_rotation(0)
	emit_signal("destination_set", destination_instance)
	current_destination = destination_instance

func get_random_planet(excluded_planets):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_planet = planets[rng.randi_range(0, len(planets) - 1)]
	if excluded_planets:
		while new_planet in excluded_planets:
			rng.randomize()
			new_planet = planets[rng.randi_range(0, len(planets) - 1)]
	return new_planet
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func calculate_approximately_planet_radius(planet):
	var planet_size = planet.get_node("Sprite").texture.get_size() * planet.get_node("Sprite").scale
	return sqrt(pow(planet_size.x,2) + pow(planet_size.y,2))/5

func _on_Taxi_passenger_pickup(planet):
	create_destination([planet] + current_pickup_points)


func _on_Taxi_passenger_delivered(planet):
	if len(current_pickup_points) < MAX_PICKUP_POINTS_NUMBER:
		create_passenger_pickup_point(planet)


func _on_NewPassengerPickupPointTimer_timeout():
	if len(current_pickup_points) < MAX_PICKUP_POINTS_NUMBER:
		if current_destination:
			create_passenger_pickup_point(current_destination.get_parent())
		else:
			create_passenger_pickup_point(null)
