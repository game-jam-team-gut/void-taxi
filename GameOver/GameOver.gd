extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
