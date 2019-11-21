extends TextureRect
class_name Minimap

signal position_selected(position)

export var pivot_path := NodePath("Pivot")
onready var pivot: TextureRect = get_node(pivot_path)

var arena_scale := Vector2(0.1, 0.1)

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_mouse_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_mouse_exited")


func _mouse_entered() -> void:
	get_tree().call_group("local_camera", "claim_mouse", self)


func _mouse_exited() -> void:
	get_tree().call_group("local_camera", "free_mouse", self)


func load_arena(arena: Arena) -> void:
	arena_scale = arena.minimap_scale
	texture = arena.minimap_texture


func _gui_input(event: InputEvent) -> void:
	var rect := Rect2(Vector2(), rect_size)
	var local_position := get_local_mouse_position()
	if Input.is_action_pressed("minimap_selected_mouse") && rect.has_point(local_position):
		if event is InputEventMouseMotion || event.is_action_pressed("minimap_selected_mouse"):
			emit_signal("position_selected", _to_world(local_position))


func _camera_position_changed(position: Vector2) -> void:
	pivot.rect_position = _to_map(position) - pivot.rect_size / 2.0


func _to_world(position: Vector2) -> Vector2:
	return (position - rect_size / 2.0) / arena_scale


func _to_map(position: Vector2) -> Vector2:
	return position * arena_scale + rect_size / 2.0
