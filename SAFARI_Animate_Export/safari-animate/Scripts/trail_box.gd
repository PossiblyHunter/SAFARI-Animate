extends CheckBox

var nodePath: NodePath = "../../../../../"
var target_node = null

func _ready() -> void:
	target_node = get_node(nodePath)

func _on_toggled(toggled_on: bool) -> void:
	target_node.trail_toggled(toggled_on)
