extends HSlider

@export var target_path: NodePath = "../../../../Ion" # Find Ion relative to this slider
var target_node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target_path.is_empty():
		print("Target path is empty slider control:", target_path)
	else:
		target_node = get_node(target_path)
	
	# Slider values
	min_value = 0
	max_value = 1
	step = 0.001

# Changes the position of the ion when slider value changes
func _on_value_changed(new_value): 
	if target_node and target_node.has_method("slider_val"):
		target_node.slider_val(new_value)

# Updates the slider when the play buttons are hit
func update_slider(tick): 
	set_value_no_signal(tick)
	queue_redraw()
