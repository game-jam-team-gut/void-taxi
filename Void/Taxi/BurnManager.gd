extends Node2D

onready var burn_timer = get_node("BurnTimer")
onready var taxi = get_parent()
onready var particles = get_node("Particles2D")

var burn_damage_per_tick = 4

var zone = 0

func _on_BurningDetector_area_entered(area):
	burn_timer.start()
	particles.set_emitting(true)
	#set sound!!!
	zone += 1
	if zone == 3:
		taxi.take_damage(10000000) # you are in the sun


func _on_BurningDetector_area_exited(area):
	burn_timer.stop()
	particles.set_emitting(false)
	zone -= 1


func _on_BurnTimer_timeout():
	taxi.take_damage(burn_damage_per_tick)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	burn_damage_per_tick = rng.randi_range(zone * 2, zone * 5)
