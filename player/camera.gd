extends Camera2D

signal position_changed(position)

onready var remote_transform := $".."

var _claimers := []

func claim_mouse(claimer: Object) -> void:
	_claimers.append(claimer)


func free_mouse(claimer: Object) -> void:
	_claimers.erase(claimer)


func follow_target(target: Node2D) -> void:
	position = Vector2()
	remote_transform.position = Vector2()
	remote_transform.remote_path = remote_transform.get_path_to(target)


func move(relative: Vector2) -> void:
	snap_to_point(position + relative)


func snap_to_point(point: Vector2) -> void:
	if remote_transform.remote_path:
		remote_transform.remote_path = null
		remote_transform.position = Vector2()
	position = point
	emit_signal("position_changed", global_position)


func _process(delta: float) -> void:
	if remote_transform.remote_path:
		emit_signal("position_changed", global_position)
		return
	
	if !_claimers.empty():
		return
	
	var camera_speed: float = ProjectSettings.get("pixelMOBA/camera_speed")
	var camera_threshold: Vector2 = ProjectSettings.get("pixelMOBA/camera_threshold")
	var mouse_position := get_tree().root.get_mouse_position()
	var bounds := get_tree().root.get_visible_rect().size
	
	var movement := Vector2()
	if mouse_position.x <= camera_threshold.x:
		movement.x -= camera_speed * delta
	elif mouse_position.x >= bounds.x - camera_threshold.x:
		movement.x += camera_speed * delta
	
	if mouse_position.y <= camera_threshold.y:
		movement.y -= camera_speed * delta
	elif mouse_position.y >= bounds.y - camera_threshold.y:
		movement.y += camera_speed * delta
	
	move(movement)
