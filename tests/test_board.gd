extends Node2D

var frame: int = 0
@onready var board: Board = $Board
@onready var l_shape: Shape = $LShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(board.block_sensor_from_cell)
	print()

func _on_l_shape_released(shape: Shape) -> void:
	board.drop_shape(shape)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if frame == 8:
				return
			frame += 1
			l_shape.set_frame(frame)
