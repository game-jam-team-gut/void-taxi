extends Area2D

var available_passengers setget ,get_available_passengers
var player
var player_pos

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	available_passengers = rng.randi_range(1, 3)
	yield(get_tree().create_timer(.1), "timeout")
	player = get_node("/root/Main").player_taxi
	player_pos = player.position

func get_available_passengers():
	return available_passengers



func _on_Timer_timeout():
	player_pos = player.position
