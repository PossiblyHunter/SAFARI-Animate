extends HSlider

var nodePath: NodePath = "../../../../../../Ion"
var target_node = null

func _ready() -> void:
	target_node = get_node(nodePath)

func _on_value_changed(value: float) -> void:
	target_node.set_radius(value)
