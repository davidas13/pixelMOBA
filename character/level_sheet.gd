extends Resource
class_name LevelSheet

export var xp_list := [
	0,
	100,
	200,
	300,
	400,
	500,
	600,
	700
]

# warning-ignore:unused_class_variable
export var stats := [
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
	{"max_health": 0, "max_magic": 0, "strength": 0, "wisdom": 0, "defence": 0, "agility": 0},
]

# warning-ignore:unused_class_variable
export var abilities := [
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null]
]

func get_required_xp(level: int) -> int:
	if level >= xp_list.size() - 1: # max level reached
		return -1
	return xp_list[level + 1]
