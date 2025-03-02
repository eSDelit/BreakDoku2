class_name BlockSensor
extends Node2D

var blocked: bool = false
var deblocking: bool = false
var layers: Array[TileMapLayer] = []
@onready var block_sprite: Sprite2D = $BlockSprite

func block():
	blocked = true
	visible = true

func deblock():
	deblocking = true

func apply_deblock():
	blocked = false
	visible = false
	deblocking = false

func _to_string() -> String:
	return str(blocked)
