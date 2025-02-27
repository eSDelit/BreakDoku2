extends Node2D

@export var spawns: Array[Spawn]
@onready var board: Board = $Board
var n_shapes: int = 0
var score: int = 0
var shapes: Array[Shape] = []

func on_shape_released(shape: Shape):
	if board.drop_shape(shape):
		n_shapes -= 1
		var i: int = shapes.find(shape)
		shapes.remove_at(i)
		call_deferred("all_shapes_droppable")
	if n_shapes == 0:
		spawn_all()

func spawn_all():
	for spawn: Spawn in spawns:
		var shape: Shape = spawn.spawn_random_shape()
		shape.released.connect(on_shape_released)
		shape.set_frame(8)
		shapes.append(shape)
		n_shapes += 1

func _ready() -> void:
	spawn_all()

func _on_board_scored(blocks: int, layers: int) -> void:
	blocks *= layers
	score += blocks
	print(score)

func all_shapes_droppable():
	print(shapes)
	for shape in shapes:
		if shape == null:
			continue
		if board.is_shape_droppable_anywhere(shape):
			return true
	print("Game Over")
	return false
