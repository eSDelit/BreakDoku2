class_name Shape
extends Node2D

signal released(shape: Shape)

var scene: PackedScene
var blocks: Array[Block]
var grabbed = false
var grabbed_at = Vector2(0, 0)
var grabbable: bool = true
var rotated_90: int = 0

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

func rotate_90():
	rotated_90 += 1
	for block in blocks:
		var x: float = block.position.x
		var y: float = block.position.y
		block.position = Vector2(-y, x)
		var x_i: float = block.grid_pos.x
		var y_i: float = block.grid_pos.y
		block.grid_pos = Vector2(-y_i, x_i)

func copy() -> Shape:
	var shape: Shape = scene.instantiate()
	add_sibling(shape)
	shape.visible = false
	for i in range(rotated_90):
		shape.rotate_90()
	shape.set_frame(8)
	return shape
