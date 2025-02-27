class_name Board
extends TileMapLayer

class BlockSensor:
	var blocked: bool
	var deblocking: bool = false
	var layers: Array[TileMapLayer]
	var board: Board
	var block_sprite: Sprite2D
	const block_sprite_scene: PackedScene = preload("res://board/block_sprite.tscn")

	func _init(
		p_blocked: bool,
		p_layers: Array[TileMapLayer],
		p_position: Vector2,
		p_board: Board
		) -> void:
		self.blocked = p_blocked
		self.layers = p_layers
		self.board = p_board
		self.block_sprite = block_sprite_scene.instantiate()
		self.board.add_child(self.block_sprite)
		self.block_sprite.position = p_position
		self.block_sprite.visible = false
	
	func block():
		blocked = true
		block_sprite.visible = true
	
	func deblock():
		deblocking = true

	func apply_deblock():
		blocked = false
		block_sprite.visible = false
		deblocking = false

	func _to_string() -> String:
		return str(blocked)

@onready var layers: Array = get_children()
var block_sensor_from_cell: Dictionary = {}
signal scored(blocks: int, layers: int)

func _ready() -> void:
	make_score_map()

func emit_score_info():
	var blocked_layers: int = 0
	for layer: TileMapLayer in layers:
		if is_layer_blocked(layer):
			blocked_layers += 1
			for cell in layer.get_used_cells():
				var block_sensor: BlockSensor = block_sensor_from_cell[cell]
				block_sensor.deblock()
	var score: int = 0
	for cell in block_sensor_from_cell:
		var block_sensor: BlockSensor = block_sensor_from_cell[cell]
		if block_sensor.deblocking:
			block_sensor.apply_deblock()
			score += 1
	scored.emit(score, blocked_layers)

func is_shape_droppable_anywhere(shape: Shape):
	for cell in get_used_cells():
		if is_shape_droppable(shape, cell):
			print(cell)
			return true
	return false

func is_shape_droppable(shape: Shape, shape_cell: Vector2i) -> bool:
	for block in shape.blocks:
		var block_grid_pos: Vector2i = Vector2i(block.grid_pos)
		var block_cell: Vector2i = block_grid_pos + shape_cell
		if get_cell_tile_data(block_cell) == null:
			return false
		if block_sensor_from_cell[block_cell].blocked:
			return false
	return true

func drop_shape(shape: Shape) -> bool:
	var local_shape_position = shape.global_position - global_position
	var shape_cell = local_to_map(local_shape_position)
	if not is_shape_droppable(shape, shape_cell):
		return false
	for block in shape.blocks:
		set_block(block, local_shape_position)
	shape.queue_free()
	emit_score_info()
	return true

func make_score_map():
	for cell in get_used_cells():
		var cell_layers: Array[TileMapLayer] = []
		for layer: TileMapLayer in layers:
			if layer.get_cell_tile_data(cell) != null:
				cell_layers.append(layer)
		var block_sensor: BlockSensor = BlockSensor.new(false, cell_layers, map_to_local(cell), self)
		block_sensor_from_cell.get_or_add(cell, block_sensor)

func set_block(block: Block, pos: Vector2):
	var cell = local_to_map((block.position + pos))
	var block_sensor: BlockSensor = block_sensor_from_cell[cell]
	block_sensor.block()

func is_layer_blocked(layer: TileMapLayer):
	for cell in layer.get_used_cells():
		var block_sensor: BlockSensor = block_sensor_from_cell[cell]
		if not block_sensor.blocked:
			return false
	return true
