extends TextureRect

export var ready_color := Color(1.0, 1.0, 1.0)
export var cooldown_color := Color(0.75, 0.75, 0.75)

onready var vbox_container := $VBoxContainer

func _character_ability_used(ability: Ability, idx: int) -> void:
	var rect: TextureRect = vbox_container.get_child(idx)
	_tween_cooldown(rect, ability.cooldown)


func _character_ability_changed(ability: Ability, idx: int) -> void:
	var rect: TextureRect = vbox_container.get_child(idx)
	var cost_label := rect.get_node("Cost")
	if ability:
		rect.texture = ability.texture
		cost_label.text = ability.cost
	else:
		rect.texture = null
		cost_label.text = ""


func _tween_cooldown(rect: TextureRect, cooldown: float) -> void:
	var cooldown_layer: TextureProgress = rect.get_node("CooldownLayer")
	var tween: Tween = rect.get_node("Tween")
	var cost_label: Label = rect.get_node("Cost")
	cost_label.add_color_override("font_color", cooldown_color)
	
# warning-ignore:return_value_discarded
	tween.stop_all()
# warning-ignore:return_value_discarded
	tween.interpolate_property(cooldown_layer, "value", cooldown_layer.max_value, 0, cooldown, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_callback(cost_label, cooldown, "add_color_override", "font_color", ready_color)
# warning-ignore:return_value_discarded
	tween.start()
