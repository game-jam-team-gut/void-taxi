extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Story.tscn")

func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Credits.tscn")
