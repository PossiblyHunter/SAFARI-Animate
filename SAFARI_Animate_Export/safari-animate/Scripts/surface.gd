extends Node3D

# Mesh for atoms
@export var atom_mesh: Mesh # Exports it so I can select the mesh type

var multimesh_instance: MultiMeshInstance3D # Creates a MultiMeshInstance3D node
var current_frame = 0 
var max_frames = 0
var data_source # The node that I get the data from
var ion_path: NodePath = "../Ion" # Path to the ion which controls all movement 
var ion_node = null # node itself
var surf_size = 1.35 # Sets the radius of the surface particles
var p_arr = [0,0,0] # Used to find the difference in distance between two frames
var c_change = true # Decides whether color should change when colliding or not

func _ready():
	# Get reference for data source and ion_node then waits till it's done making the arrays to set the first frame up
	data_source = get_parent()
	ion_node = get_node(ion_path)
	data_source.connect("initialization_complete", ini_frame)

# What's ran once all the files are read
func ini_frame():
	# Access the position data from the other script
	var pos_data = data_source.pos
	
	# Determine the maximum number of frames
	if pos_data.size() > 0 and pos_data[0].size() > 0:
		max_frames = pos_data[0].size()
	
	# Create a MultiMeshInstance3D
	multimesh_instance = MultiMeshInstance3D.new()
	add_child(multimesh_instance)
	
	# Set up the MultiMesh
	var multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D # sets it up as a 3D model
	multimesh.mesh = atom_mesh
	multimesh.use_colors = true # Allows for colors to change
	
	# Set the number of instances to the number of atoms
	multimesh.instance_count = pos_data.size()
	
	multimesh_instance.multimesh = multimesh
	
	# Set initial positions
	set_frame(0)

# Function to update positions for a specific frame
func set_frame(frame_number):
	# sets current frame to whatever index is give
	current_frame = frame_number
	# Makes sure it doesn't go over
	if current_frame >= max_frames:
		current_frame = max_frames - 1
	
	# Update each atom's position
	await get_tree().process_frame # waits to make sure everything caught up
	var position_data = data_source.pos # makes position_data = the big array
	var multimesh = multimesh_instance.multimesh #
	
	for atom_index in range(multimesh.instance_count): # Goes through every multimesh instance
		if atom_index < position_data.size() and current_frame >= 0 and current_frame < position_data[atom_index].size():
			var pos = position_data[atom_index][current_frame] # Grabs the position for that specific atom and frame
			
			# Create transform for this atom
			var transform = Transform3D()
			transform.origin = Vector3(pos[0], pos[1], pos[2]) # moves its position
			transform = transform.scaled_local(Vector3(surf_size, surf_size, surf_size)) # sets its size
			
			# Set the transform for this instance
			multimesh.set_instance_transform(atom_index, transform)
			multimesh.set_instance_color(atom_index, Color.WHITE) # Changes it to white
			
			# Checks to see if it needs to change color
			if current_frame == 0:
				pass
			else:
				if c_change == true:
					for i in range(0,2):
						p_arr[i] = position_data[atom_index][current_frame][i] - position_data[atom_index][current_frame-1][i]
					if sqrt(p_arr[0]**2 + p_arr[1]**2 + p_arr[2]**2) > 0.001:
						multimesh.set_instance_color(atom_index, Color.DARK_RED)
			

# Used to change the size of surf_size
func change_size(val):
	surf_size = val

func collide_bool(val):
	c_change = val
