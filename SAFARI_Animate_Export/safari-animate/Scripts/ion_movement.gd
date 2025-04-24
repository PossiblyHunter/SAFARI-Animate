extends CSGSphere3D

# Create variables
var traj_data = {} # Imported trajectory data from ball_trajectory
var surf_data = [] # Imported surface data from ball_trajectory
var surf_time = [] # Imported time stampsp for surface
var c_index = 0 # Current index
var m_index = 0 # Max index
var c_time = 0.0 # Current time in traj_data
var next_time = 0.0 # The next time after c_time in traj_data
var playing = false
var atom_pos = []

# Prep for signal emission to slider
var target_path: NodePath = "../Control/VBoxContainer/Timeline_Row/HSlider"
var target_node = null

# Prep for signal emission to surface
var surf_path: NodePath = "../Surface_atoms"
var surf_node = null

# Receives the signal from parent to get ion_move data
func _ready() -> void:
	var parent = get_parent() # grabs the parent node
	target_node = get_node(target_path) # Sets target_node to the hslider for the time line
	surf_node = get_node(surf_path)
	parent.connect("initialization_complete", ion_move) # connects to that signal and waits for the parent to be done
	

### ION MOVEMENT ###
# Gets whether playing is true or not
func get_playing() -> bool:
	return playing

# Updates the ion position when the play button is hit with consistent time steps
func play():
	playing = true
	if traj_data.size() > 0:
		while playing == true: 
			if c_index >= m_index: #checks to make sure it doesn't go past final index
				playing = false
				update_pos(c_index)
				target_node.update_slider(float(c_index)/m_index)
			else:
				update_pos(c_index)
				target_node.update_slider(float(c_index)/m_index)
				c_time = traj_data["time"][c_index][0]
				next_time = traj_data["time"][c_index+1][0]
				await get_tree().create_timer(next_time - c_time).timeout # Waits the time until next frame
				c_index = c_index+1

# Stops the ion from moving
func stop():
	playing = false

# Moves the Ion forward one frame
func forward1():
	if c_index == m_index:
		pass
	else:
		c_index = c_index+1
		update_pos(c_index)
		var slider_tick = float(c_index)/m_index
		target_node.update_slider(slider_tick)

# Move the Ion back one frame
func back1():
	if c_index == 0:
		pass
	else:
		c_index = c_index-1
		update_pos(c_index)
		var slider_tick = float(c_index)/m_index
		target_node.update_slider(slider_tick)

# Function to bring ion_val to this script once it's done
func ion_move(): 
	var parent = get_parent() # Gets parent node
	traj_data = parent.ion_val # changes traj_data into ion_val from ball_trajectory
	if traj_data.size() > 0:
		m_index = traj_data["position"].size()-1 # Finds max index
		update_pos(0) # Updates to first position of the traj_data

# Function to update the position of the ion
func update_pos(index): 
	var parent = get_parent()
	if index >= 0 and index <= m_index: # Checks to make sure the index is between 0 and max
		var pos = traj_data["position"][index]
		var mom = traj_data["momentum"][index]
		position = Vector3(pos[0], pos[1], pos[2])
		var momentum = Vector3(mom[0], mom[1], mom[2])
		update_label(position[0], position[1], position[2], momentum[0], momentum[1], momentum[2], traj_data["time"][index])
		update_surf(index)
		parent.update_trail(index)

func slider_val(value):
	# Maps slider value (0-1) to trajectory index and changes position based on that
	c_index = int(value * m_index)
	update_pos(c_index)

func update_label(x, y, z, px, py, pz, t):
	var label_path: NodePath = "../Control/Container/Label"
	var label_node = get_node(label_path)
	label_node.change_val(x, y, z, px, py, pz, t)

### Surface Movement ###
# Function to update the position of the surface
func update_surf(ind):
	surf_node.set_frame(ind)
