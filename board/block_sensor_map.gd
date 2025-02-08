extends TileMapLayer

var cells

func _ready() -> void:
	cells = get_used_cells()
