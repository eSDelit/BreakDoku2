extends Node2D

var frame: int = 0

func _on_l_shape_released(shape: Shape) -> void:
	$Board.drop_shape(shape)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if frame == 8:
				return
			frame += 1
			$LShape.set_frame(frame)
