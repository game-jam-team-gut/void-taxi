extends Sprite


var destination = null setget set_destination

var should_be_hidden = false

var R = 150

func _ready():
	pass # Replace with function body.

func set_destination(dest):
	destination = dest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if destination != null and !should_be_hidden:
		show()
		rotation = global_position.angle_to_point(destination.global_position) + (3 * PI)/2
		position = get_parent().get_parent().global_position + Vector2(R, 0).rotated(rotation + (3 * PI)/2)
	else:
		hide()
