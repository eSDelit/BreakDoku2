class_name Shape
extends Node2D

signal released(shape: Shape)

var blocks: Array[Block]
var grabbed = false
var grabbed_at = Vector2(0, 0)
var grabbable: bool = true

func set_frame(frame: int):
	for block in blocks:
		block.frame = frame
		block.position = block.grid_pos * block.rect.size

func _on_grabbed(pos: Vector2, block: Block):
	if !grabbable:
		return
	grabbed = true
	grabbed_at = block.position + pos

func _on_released():
	if !grabbable:
		return
	grabbed = false
	released.emit(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		global_position = get_global_mouse_position() - grabbed_at
		print(global_position)
		print(get_global_mouse_position())
		print(grabbed_at)
		print()
