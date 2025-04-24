extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("1.35")

func _on_surf_slider_value_changed(value: float) -> void:
	if int(value*100) % 10 != 0:
		set_text(str(value))
	elif value == 1:
		set_text(str(value)+".00")
	else:
		set_text(str(value)+"0")
