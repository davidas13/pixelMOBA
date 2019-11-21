extends Node2D
class_name Character

const MAX_PREFIX := "max_"

signal level_changed(value)
signal xp_changed(value, required)
signal stats_changed(stats)
signal bonus_changed(bonus_stats)

signal damage_received(amount)
# warning-ignore:unused_signal
signal damage_dealt(amount)

signal died(source)
# warning-ignore:unused_signal
signal killed(target)

signal ability_changed(ability, idx)
signal ability_used(ability, idx)

onready var area := $Area2D
onready var sprite := $Sprite
onready var tween := $Tween

export var level_sheet: Resource = null

var stats := {
	"health": 0,
	"magic": 0,
	"max_health": 0,
	"max_magic": 0,
	
	"strength": 0,
	"wisdom": 0,
	"defence": 0,
	"agility": 0
}


var bonus_stats := {
	"health": 0,
	"magic": 0,
	"strength": 0,
	"wisdom": 0,
	"defence": 0,
	"agility": 0
}

var level := 0
var xp := 0
var abilities := [null, null, null]
var ability_cooldown := []

var path := PoolVector2Array()

func _process(delta: float) -> void:
	if path.empty():
		return
	
	var to_point: Vector2 = path[0] - sprite.position
	var i := 0
	if path.size() > 1 && path[0].direction_to(path[1]) == -to_point.normalized():
		i = 1
	
	sprite.position = sprite.position.move_toward(path[i], (stats.agility + bonus_stats.agility) * delta)


func _physics_process(delta: float) -> void:
	if path.empty():
		return
	
	var length: float = (stats.agility + bonus_stats.agility) * delta
	while length > 0.0 && path.size() > 0:
		var to_point: Vector2 = path[0] - area.position
		if path.size() > 1 && path[0].direction_to(path[1]) == -to_point.normalized():
			path.remove(0)
			to_point = path[0] - area.position
		
		if length * length <= to_point.length_squared():
			area.position += to_point.normalized() * length
			length = 0.0
		else:
			length -= to_point.length()
			area.position += to_point
			path.remove(0)
	
	sprite.position = area.position


func initialize() -> void:
	emit_signal("bonus_changed", bonus_stats)
	_learn_abilities()
	emit_signal("level_changed", level)
	emit_signal("xp_changed", xp, level_sheet.get_required_xp(level))
	_update_stats()


func gain_experience(amount: int) -> void:
	var required: int = level_sheet.get_required_xp(level)
	
	if required < 0:
		return
	
	xp += amount
	if xp < required:
		emit_signal("xp_changed", xp, required)
		return
	
	while xp >= required:
		xp -= required
		level += 1
		required = level_sheet.get_required_xp(level)
		if required < 0:
			xp = 0
			break
	
	_learn_abilities()
	emit_signal("xp_changed", xp, required)
	_update_stats()
	emit_signal("level_changed", level)


func update_boni(boni: Dictionary) -> void:
	for property in boni.keys():
		bonus_stats[property] = boni[property]
	emit_signal("bonus_changed", bonus_stats)


func take_damage(amount: int, source = null) -> void:
	amount -= stats.defence
	if amount > 0:
		source.emit_signal("damage_dealt", amount)
		emit_signal("damage_received", amount)
		
		var bonus_health: int = bonus_stats.get("health", 0)
		if bonus_health > 0:
# warning-ignore:narrowing_conversion
			var new_bonus: int = max(0, bonus_health - amount)
			bonus_stats["health"] = new_bonus
			emit_signal("bonus_changed", bonus_stats)
			amount -= bonus_health
		
		if amount > 0:
			stats.health -= amount
			emit_signal("stats_changed", stats)
			if stats.health <= 0:
				emit_signal("died", source)
				source.emit_signal("killed", self)


func use_ability(idx: int) -> void:
	var ability: Ability = abilities[idx]
	if ability && !(idx in ability_cooldown):
		var cost := ability.cost
		var bonus_magic: int = bonus_stats.get("magic", 0)
		if cost <= bonus_magic + stats.magic:
			if bonus_magic > 0:
				var new_bonus: int = max(0, bonus_magic - cost)
				bonus_stats["magic"] = new_bonus
				emit_signal("bonus_changed", bonus_stats)
				cost -= bonus_magic
			
			if cost > 0:
				stats.magic -= cost
				cost = 0
				emit_signal("stats_changed", stats)
			
			if cost <= 0:
				ability.action_script.use(self)
				emit_signal("ability_used", ability, idx)
				ability_cooldown.append(idx)
				yield(get_tree().create_timer(ability.cooldown), "timeout")
				ability_cooldown.erase(idx)


func _learn_abilities() -> void:
	for i in range(level_sheet.abilities[level].size()):
		var ability: Ability = level_sheet.abilities[level][i]
		if ability:
			abilities[i] = ability
			emit_signal("ability_changed", ability, i)


func _update_stats() -> void:
	var level_stats: Dictionary = level_sheet.stats[level]
	for property in level_stats.keys():
		stats[property] = level_stats[property]
		if property.begins_with(MAX_PREFIX):
			stats[property.trim_prefix(MAX_PREFIX)] = level_stats[property]
	
	emit_signal("stats_changed", stats)
