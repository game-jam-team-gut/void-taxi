extends Node


onready var asteroid_one = preload("res://Void/Asteroids/Asteroid1.tscn")

onready var minimap_camera = get_node("/root/Main/MinimapViewportContainer/Viewport/Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	var camera_center = minimap_camera.get_camera_screen_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(minimap_camera)
