class_name Board
extends TileMapLayer

var layers: Array[BlockSensorLayer]
var block_sensor_from_cell: Dictionary = {}
signal scored(blocks: int, layers: int)

func _ready() -> void:
	make_score_map()
	layers.assign(find_children("*", "BlockSensorLayer"))

func get_blocked_layers() -> Array[BlockSensorLayer]:
	var blocked_layers: Array[BlockSensorLayer] = []
	for layer in layers:
		if is_layer_blocked(layer):
			blocked_layers.append(layer)
	return blocked_layers

func mark_layers_for_deblock(blocked_layers: Array[BlockSensorLayer]):
	for layer: BlockSensorLayer in blocked_layers:
		for cell in layer.get_used_cells():
			var block_sensor: BlockSensor = block_sensor_from_cell[cell]
			block_sensor.deblock()

func apply_deblocks() -> int:
	var score: int = 0
	for cell in block_sensor_from_cell:
		var block_sensor: BlockSensor = block_sensor_from_cell[cell]
		if block_sensor.deblocking:
			block_sensor.apply_deblock()
			score += 1
	return score

func emit_score_info():
	var blocked_layers: Array[BlockSensorLayer] = get_blocked_layers()
	mark_layers_for_deblock(blocked_layers)
	var score: int = apply_deblocks()
	var n_blocked_layers: int = len(blocked_layers)
	scored.emit(score, n_blocked_layers)

func is_shape_droppable_anywhere(shape: Shape) -> bool:
	var shape_to_check = shape.copy()
	for cell in get_used_cells():
		for block: Block in shape_to_check.blocks:
			shape_to_check.global_position = to_global(map_to_local(cell)) - block.position
			if is_shape_droppable(shape_to_check):
				shape_to_check.queue_free()
				return true
	shape_to_check.queue_free()
	return false

func is_shape_droppable(shape: Shape) -> bool:
	for block in shape.blocks:
		var block_grid_pos: Vector2i = local_to_map(block.global_position - global_position)
		var block_cell: Vector2i = block_grid_pos
		if get_cell_tile_data(block_cell) == null:
			return false
		if block_sensor_from_cell[block_cell].blocked:
			return false
	return true

func drop_shape(shape: Shape) -> bool:
	if not is_shape_droppable(shape):
		return false
	var local_shape_position = shape.global_position - global_position
	for block in shape.blocks:
		set_block(block, local_shape_position)
	shape.queue_free()
	emit_score_info()
	return true

func make_score_map():
	var block_sensor_scene: PackedScene = load("res://board/block_sensor.tscn")
	for cell in get_used_cells():
		var cell_layers: Array[BlockSensorLayer] = []
		for layer: BlockSensorLayer in layers:
			if layer.get_cell_tile_data(cell) != null:
				cell_layers.append(layer)
		var block_sensor: BlockSensor = block_sensor_scene.instantiate()
		add_child(block_sensor)
		block_sensor.position = map_to_local(cell)
		block_sensor.layers = cell_layers
		block_sensor_from_cell.get_or_add(cell, block_sensor)

func set_block(block: Block, pos: Vector2):
	var cell = local_to_map((block.position + pos))
	var block_sensor: BlockSensor = block_sensor_from_cell[cell]
	block_sensor.block()

func is_layer_blocked(layer: BlockSensorLayer):
	for cell in layer.get_used_cells():
		var block_sensor: BlockSensor = block_sensor_from_cell[cell]
		if not block_sensor.blocked:
			return false
	return true
