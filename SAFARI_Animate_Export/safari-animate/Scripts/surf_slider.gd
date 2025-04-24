extends HSlider

var nodePath: NodePath = "../../../../../../Surface_atoms"
var target_node = null

func _ready() -> void:
	target_node = get_node(nodePath)

func _on_value_changed(value: float) -> void:
	target_node.change_size(value)
