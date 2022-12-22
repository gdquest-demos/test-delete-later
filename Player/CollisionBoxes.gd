extends Marker2D


func set_direction(x_direction: float) -> void:
	if x_direction != 0:
		scale.x = sign(x_direction)
