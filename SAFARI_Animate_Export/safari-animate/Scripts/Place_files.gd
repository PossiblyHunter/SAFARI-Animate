extends Label

var file_path: NodePath = "../../../../Node3D"

func _ready() -> void:
	self.visible = false
	var file_node = get_node(file_path)
	file_node.connect("no_file", disp_label)


func disp_label():
	self.visible = true
