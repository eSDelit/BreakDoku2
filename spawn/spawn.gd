class_name Spawn
extends Node2D

const shapes: Array[PackedScene] = [
	preload("res://shapes/i_shape.tscn"),
	preload("res://shapes/l_shape.tscn"),
	preload("res://shapes/t_shape.tscn")
	]

func spawn_random_shape():
	var f: float = randf()
	var s: int = len(shapes)
	var i: int = s * f
	add_child(shapes[i].instantiate())
