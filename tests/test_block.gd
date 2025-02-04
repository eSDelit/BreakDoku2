extends Node2D

var grabbed = false
var grabbed_at = Vector2(0, 0)
@onready var block: AnimatedSprite2D = $Block

func _on_block_grabbed(pos: Vector2, _block: AnimatedSprite2D) -> void:
	grabbed = true
	grabbed_at = pos

func _on_block_released() -> void:
	grabbed = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		block.position = event.position - grabbed_at
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			block.frame += 1
