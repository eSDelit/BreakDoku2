class_name Board
extends TileMapLayer

class ScoreField:
	var blocked: int
	var group: Array[ScoreField]
	
@onready var score_maps = get_children()
var score_map: Dictionary = {}

func drop_shape(shape: Shape):
	var loc = to_local(shape.position)
	var cell = local_to_map(loc)
	if get_cell_tile_data(cell) == null:
		return
	shape.position = map_to_local(cell) + position
	shape.grabbable = false

func make_scores():
	for layer in score_maps:
		var tile_map_layer: TileMapLayer = layer
		var cells = tile_map_layer.get_used_cells()
