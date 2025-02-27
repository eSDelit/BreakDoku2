extends Node2D

var frame: int = 0
var score: int = 0
@onready var spawn: Spawn = $Spawn
@onready var board: Board = $Board

func _on_l_shape_released(shape: Shape) -> void:
	var dropped: bool = board.drop_shape(shape)
	if dropped:
		var new_shape: Shape = spawn.spawn_random_shape()
		new_shape.connect("released", _on_l_shape_released)
		new_shape.set_frame(8)

func _on_button_pressed() -> void:
	var shape: Shape = spawn.spawn_random_shape()
	shape.connect("released", _on_l_shape_released)
	shape.set_frame(8)


func _on_board_scored(score: int, layers) -> void:
	score *= layers
	self.score += score
	print(self.score)
