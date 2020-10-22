extends Node

onready var asteroid_one = preload("res://Void/Asteroids/Asteroid1.tscn")

onready var minimap_camera = get_node("/root/Main/MinimapViewportContainer/Viewport/Camera2D")

func _ready():
	var camera_center = minimap_camera.get_camera_screen_center()
