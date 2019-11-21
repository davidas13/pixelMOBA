extends TextureRect
class_name CustomProgressBar

export var child_receiver_path := NodePath(".")
export var label_path := NodePath("Label")
export var progress_bit: Texture = null
export var bits := 1

onready var child_receiver: Control = get_node(child_receiver_path)
# warning-ignore:unused_class_variable
onready var label: Label = get_node(label_path)


func set_progress(current: int, maximum: int) -> void:
	var amount := float(bits) * current / maximum
	if maximum < 0:
		amount = bits
	
	while child_receiver.get_child_count() > amount:
		var back_child: Node= child_receiver.get_children().back()
		child_receiver.remove_child(back_child)
		back_child.queue_free()
	
	while child_receiver.get_child_count() < amount:
		var texture_rect := TextureRect.new()
		texture_rect.texture = progress_bit
		texture_rect.rect_size = progress_bit.get_size()
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		child_receiver.add_child(texture_rect)
