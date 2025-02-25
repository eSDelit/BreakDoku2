extends Node2D

@onready var spawn: Spawn = $Spawn
@onready var spawn_2: Spawn = $Spawn2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	spawn.spawn_random_shape()


func _on_button_2_pressed() -> void:
	spawn_2.spawn_random_shape()
