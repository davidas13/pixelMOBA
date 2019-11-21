extends TextureRect

export var bonus_color := Color("5ce56c")

onready var label := $Label

var _value := 0
var _bonus := 0

func set_value(value: int) -> void:
	_value = value
	_update_label()


func set_bonus(bonus: int) -> void:
	_bonus = bonus
	_update_label()


func _update_label() -> void:
	var color := bonus_color if _bonus > 0 else Color(1.0, 1.0, 1.0)
	label.add_color_override("font_color", color)
	label.text = "%03d" % (_value + _bonus)
