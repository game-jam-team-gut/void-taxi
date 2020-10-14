extends PathFollow2D


export (float) var move_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	unit_offset += (delta/10000) * move_speed
