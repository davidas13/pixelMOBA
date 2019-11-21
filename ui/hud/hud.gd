extends Control

onready var level_label := $IconBox/LevelBox/LevelLabel
onready var xp_bar := $XpBar
onready var stats_bar := {
	"health": $HealthBar,
	"magic": $MagicBar
}
onready var bonus_bars := {
	"health": [$BonusHealthBar, 50],
	"magic": [$BonusMagicBar, 30]
}
onready var icon_stats := {
	"strength": $IconStats/StrengthIcon,
	"defence": $IconStats/DefenceIcon,
	"wisdom": $IconStats/WisdomIcon,
	"agility": $IconStats/AgilityIcon
}
# warning-ignore:unused_class_variable
onready var minimap := $MapBox/Minimap
# warning-ignore:unused_class_variable
onready var ability_container := $AbilityContainer

func _character_level_changed(level: int) -> void:
	level_label.text = str(level + 1)


func _character_xp_changed(amount: int, required: int) -> void:
	xp_bar.set_progress(amount, required)
	if required > 0:
		xp_bar.label.text = "%04d / %04d" % [amount, required]
	else:
		xp_bar.label.text = tr("Max Level")


func _character_stats_changed(stats: Dictionary) -> void:
	for property in stats.keys():
		var value: float = stats.get(property, 0.0)
		if property in icon_stats.keys():
			icon_stats[property].set_value(value)
		elif property in stats_bar.keys():
			var status_bar: CustomProgressBar = stats_bar[property]
			var maximum: float = stats.get(Character.MAX_PREFIX + property, 0.0)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
			status_bar.set_progress(value, maximum)
			status_bar.label.text = "%03d" % value


func _character_bonus_changed(bonus_stats: Dictionary) -> void:
	for property in bonus_stats.keys():
		var value: float = bonus_stats[property]
		if property in bonus_bars.keys():
			var data: Array = bonus_bars[property]
			var bar: CustomProgressBar = data[0]
	# warning-ignore:narrowing_conversion
			bar.set_progress(value, data[1])
			if value > 0:
				bar.label.text = "+%02d" % value
			else:
				bar.label.text = ""
		elif property in icon_stats.keys():
			icon_stats[property].set_bonus(value)

