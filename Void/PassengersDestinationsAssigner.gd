extends Node


var planets

onready var passenger_pickup_object = preload("res://Void/PassengerPickupPoint.tscn")
onready var destination_object = preload("res://Void/DestinationPoint.tscn")

func _ready():
	planets = get_tree().get_nodes_in_group("Planet")
	create_passenger_pickup_point() #first passenger

func create_passenger_pickup_point():
	var passenger_pickup_point_instance = passenger_pickup_object.instance()
	var planet = get_random_planet(null)
	planet.add_child(passenger_pickup_point_instance)
	var planet_size = planet.get_node("Sprite").texture.get_size()
	var r = sqrt(pow(planet_size.x,2) + pow(planet_size.y,2))/5
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-r, r)
	rng.randomize()
	var y = rng.randf_range(-r, r)
	passenger_pickup_point_instance.position = Vector2(x, y)
	passenger_pickup_point_instance.set_global_rotation(0)


func create_destination(excluded_planet):
	var destination_instance = destination_object.instance()
	var planet = get_random_planet(excluded_planet)
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

func get_random_planet(excluded_planet):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var excluded_index = planets.find(excluded_planet)
	var planet_index = rng.randi_range(0, len(planets) - 1)
	while planet_index == excluded_index:
		rng.randomize()
		planet_index = rng.randi_range(0, len(planets) - 1)
	return planets[planet_index]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Taxi_passenger_pickup(planet):
	create_destination(planet)


func _on_Taxi_passenger_delivered():
	create_passenger_pickup_point()
