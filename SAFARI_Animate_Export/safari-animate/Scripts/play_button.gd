extends TextureButton

@export var target_path: NodePath = "../../../../Ion" # Find Ion relative to this slider
var target_node = null 

func _ready() -> void:
	set_process_unhandled_key_input(false)
	if target_path.is_empty():
		print("Target path is empty play button")
	else:
		target_node = get_node(target_path)

# When pressed signals the ion to move
func _on_pressed():
	if target_node.get_playing() == true:
		return
	else:
		target_node.play()
