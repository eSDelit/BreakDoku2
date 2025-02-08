class_name Board
extends TileMapLayer

class BlockSensor:
	var blocked: bool
	var layers: Array[TileMapLayer]

	func _init(blocked: bool, layers: Array[TileMapLayer]) -> void:
		self.blocked = blocked
		self.layers = layers

	func _to_string() -> String:
		return str(blocked, " ", str(layers))

var block_sensor_from_cell: Dictionary = {}
@onready var block_sprite_scene: PackedScene = preload("res://board/block_sprite.tscn")

func _ready() -> void:
	make_score_map()

func drop_shape(shape: Shape):
	var loc = to_local(shape.position)
	var cell = local_to_map(loc)
	if get_cell_tile_data(cell) == null:
		return
	shape.position = map_to_local(cell) + position
	shape.grabbable = false
	for block in shape.blocks:
		set_block(block, shape.position)
	shape.queue_free()

func make_score_map():
	for cell in get_used_cells():
		var layers: Array[TileMapLayer] = []
		for layer: TileMapLayer in get_children():
			if layer.get_cell_tile_data(cell) != null:
				layers.append(layer)
		var block_sensor: BlockSensor = BlockSensor.new(false, layers)
		block_sensor_from_cell.get_or_add(cell, block_sensor)
	for layer: TileMapLayer in get_children():
		layer.queue_free()

func set_block(block: Block, pos: Vector2):
	var cell = local_to_map((block.position + to_local(pos)))
	var block_sensor: BlockSensor = block_sensor_from_cell[cell]
	block_sensor.blocked = true
	var block_sprite: Sprite2D = block_sprite_scene.instantiate()
	add_child(block_sprite)
	block_sprite.position = map_to_local(cell)
