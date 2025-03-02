extends Node2D

@export var spawns: Array[Spawn]
@onready var board: Board = $Board
@onready var label_score: Label = $LabelScore
@onready var label_last_score: Label = $LabelLastScore
var n_shapes: int = 0
var score: int = 0
var shapes: Array[Shape] = []

func on_shape_released(shape: Shape):
	if board.drop_shape(shape):
		n_shapes -= 1
		var i: int = shapes.find(shape)
		shapes.remove_at(i)
		if n_shapes == 0:
			spawn_all()
		is_game_over()
	else:
		shape.position = Vector2.ZERO

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
	label_score.text = str(score)
	label_last_score.text = "+" + str(blocks)
	$LabelLastScore/Timer.start()
	print(score)

func is_game_over():
	if !board.any_shape_droppable(shapes):
		print("Game Over")

func _on_timer_timeout() -> void:
	label_last_score.text = ""
