class_name Spawn
extends Node2D

const shapes: Array[PackedScene] = [
	preload("res://shapes/i_shape.tscn"),
	preload("res://shapes/l_shape.tscn"),
	preload("res://shapes/t_shape.tscn"),
	preload("res://shapes/rl_shape.tscn"),
	preload("res://shapes/rz_shape.tscn"),
	preload("res://shapes/z_shape.tscn"),
	preload("res://shapes/q_shape.tscn")
	]

func spawn_random_shape() -> Shape:
	var f: float = randf()
	var s: int = len(shapes)
	var i: int = floori(s * f)
	var scene: PackedScene = shapes[i]
	var shape: Shape = scene.instantiate()
	shape.scene = scene
	add_child(shape)
	var r: int = floori(randf() * 3)
	for t in range(r):
		shape.rotate_90()
	return shape
