extends TextureRect

onready var vbox_container := $VBoxContainer

func _character_ability_used(ability: Ability, idx: int) -> void:
	var rect: TextureRect = vbox_container.get_child(idx)
	var cooldown_layer := rect.get_node("CooldownLayer")
	var tween := rect.get_node("Tween")
	_tween_cooldown(tween, cooldown_layer, ability.cooldown)


func _character_ability_changed(ability: Ability, idx: int) -> void:
	pass


func _tween_cooldown(tween: Tween, cooldown_layer: TextureProgress, cooldown: float) -> void:
# warning-ignore:return_value_discarded
	tween.stop_all()
# warning-ignore:return_value_discarded
	tween.interpolate_property(cooldown_layer, "value", cooldown_layer.max_value, 0, cooldown, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
	tween.start()
