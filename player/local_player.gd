extends Node2D
class_name LocalPlayer

onready var camera := $RemoteTransform2D/Camera2D
onready var hud := $CanvasLayer/HUD

var arena: Arena = null
var character: Character = null

func _ready() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	yield(get_tree(), "idle_frame")
	hud.minimap.load_arena(arena)
	hud.minimap.connect("position_selected", camera, "snap_to_point")
# warning-ignore:return_value_discarded
	camera.connect("position_changed", hud.minimap, "_camera_position_changed")
	if character:
# warning-ignore:return_value_discarded
		character.connect("level_changed", hud, "_character_level_changed")
# warning-ignore:return_value_discarded
		character.connect("xp_changed", hud, "_character_xp_changed")
		# warning-ignore:return_value_discarded
		character.connect("stats_changed", hud, "_character_stats_changed")
		# warning-ignore:return_value_discarded
		character.connect("bonus_changed", hud, "_character_bonus_changed")
		
# warning-ignore:return_value_discarded
		character.connect("ability_used", hud.ability_container, "_character_ability_used")
# warning-ignore:return_value_discarded
		character.connect("ability_changed", hud.ability_container, "_character_ability_changed")
		
		character.initialize()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tile_selected_mouse"):
		var mouse_position := get_tree().root.get_mouse_position()
		var bounds := get_tree().root.get_visible_rect().size
		
		var transformed_position: Vector2 = mouse_position - bounds / 2.0 + camera.get_camera_position()
		var path := arena.get_world_path(character.area.position, transformed_position)
		character.path = path
		$Line2D.points = path
