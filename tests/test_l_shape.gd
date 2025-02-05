extends Node2D

var frame = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			frame += 1
			$LShape.set_frame(frame)
