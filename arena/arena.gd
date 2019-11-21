extends Node2D
class_name Arena

export var map_path := NodePath("TileMap")
# warning-ignore:unused_class_variable
export var minimap_scale := Vector2(0.1, 0.1)
# warning-ignore:unused_class_variable
export var minimap_texture: Texture = null

onready var map: TileMap = get_node(map_path)

var astar := AStar2D.new()

func _ready() -> void:
	generate_paths()
	get_tree().call_group("player", "set", "arena", self)
	get_tree().call_group("player", "set", "character", $Character)


func generate_paths() -> void:
	astar.clear()
	var rect: Rect2 = map.get_used_rect()
	
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			var id: int = map.get_cell(x, y)
			if is_cell_walkable(id):
				var pos := Vector2(x, y)
				var path_id: int = get_path_id(pos)
				astar.add_point(path_id, pos)
				
				var neighbours := [
					Vector2(x, y - 1),
					Vector2(x + 1, y),
					Vector2(x, y + 1),
					Vector2(x - 1, y)
				]
				
				for neighbour in neighbours:
					if rect.has_point(neighbour):
						var _id := map.get_cellv(neighbour)
						if is_cell_walkable(_id):
							var _path_id := get_path_id(neighbour)
							astar.add_point(_path_id, neighbour)
							astar.connect_points(path_id, _path_id)
				


func get_path_id(pos: Vector2) -> int:
	var rect: Rect2 = map.get_used_rect()
	return int((pos.x - rect.position.x) * rect.size.y + (pos.y - rect.position.y))


func is_cell_walkable(id: int) -> bool:
	var tileset := map.tile_set
	return id >= 0 && tileset.tile_get_shape_count(id) == 0


func get_astar_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var _from: int = astar.get_closest_point(from)
	var _to: int = astar.get_closest_point(to)
	return astar.get_point_path(_from, _to)


func get_world_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var array := PoolVector2Array([])
	var astar_path := get_astar_path(map.world_to_map(from), map.world_to_map(to))
	for point in astar_path:
		array.append(map.map_to_world(point))
	return array


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$Character.gain_experience(101)
