class_name Block
extends AnimatedSprite2D

var is_grabbed: bool
signal grabbed(pos : Vector2, block : AnimatedSprite2D)
signal released

var rect = Rect2()
var grid_pos: Vector2 = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_frame_changed()
	var shape: Shape = get_parent()
	shape.blocks.append(self)
	grabbed.connect(shape._on_grabbed)
	released.connect(shape._on_released)
	grid_pos = position / rect.size

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released() and is_grabbed:
				released.emit()
				is_grabbed = false
			elif rect.has_point(to_local(event.position)):
				grabbed.emit(to_local(event.position), self)
				is_grabbed = true


func _on_frame_changed() -> void:
	var frame_text = sprite_frames.get_frame_texture(animation, frame)
	var frame_text_width = frame_text.get_width()
	var frame_text_height = frame_text.get_height()
	var size = Vector2(frame_text_width, frame_text_height)
	rect.size = size
	rect.position = -(size / 2)
