extends Node2D

@onready var board: Board = $Board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in board.score_maps:
		var map: TileMapLayer = node
		print(map.get_used_cells())
