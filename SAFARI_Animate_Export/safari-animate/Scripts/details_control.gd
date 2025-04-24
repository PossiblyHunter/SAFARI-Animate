extends Label

func change_val(cx, cy, cz, cpx, cpy, cpz, t):
	set_text("Position: [" + str(cx) + ", " + str(cy) + ", " + str(cz) + "]\nMomentum: [" + str(cpx) + ", " + str(cpy) + ", " + str(cpz) + "]\nTime: " + str(t))
