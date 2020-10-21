extends Node2D

onready var player_taxi = get_node("MainViewportContainer/Viewport/Void/Taxi")
onready var minimap_camera = get_node("MinimapViewportContainer/Viewport/Camera2D")

func _ready():
	$MinimapViewportContainer/Viewport.world_2d = $MainViewportContainer/Viewport.world_2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	minimap_camera.position = player_taxi.position
