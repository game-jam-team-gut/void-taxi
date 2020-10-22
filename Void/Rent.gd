extends Label

const ANIMATION_TIME = 5.0

onready var tween = $Tween

func _on_Timer_timeout():
	if not tween.is_active():
		tween.start()
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, ANIMATION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
