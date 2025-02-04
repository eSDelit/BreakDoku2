class_name Shape
extends Node2D

var blocks: Array[Block]
var grabbed = false
var grabbed_at = Vector2(0, 0)

func set_frame(frame: int):
	for block in blocks:
		block.frame = frame
		block.position = block.grid_pos * block.rect.size

func _on_grabbed(pos: Vector2, block: Block):
	grabbed = true
	grabbed_at = block.position + pos

func _on_released():
	grabbed = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		position = event.position - grabbed_at
