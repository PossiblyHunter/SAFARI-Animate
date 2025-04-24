extends Node3D

# Declaring variables
var ion_val = {} # Dictionary with the time assigned to the array carrying a 2 x 3 w/ x y z and px py pz
var pos = [[]] # Each array contains all the frames [[x,y,z,x,y,z] (atom1), [x,y,z,x,y,z] (atom2)] of each atom
var surf_t = [] # time stamps for surface
var c_arr = [] # current array
var t_pos = [] # Position array for trail
@onready var trail = $MeshInstance3D # used to create the trail
var trail_on = true # sets whether trail exists or not

# Prepping signal for movement
signal initialization_complete
signal no_file

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_collision_data() # Loads the .traj file
	surf_movement() # Loads the .xyz file
	emit_signal("initialization_complete") # Tells other programs it's done
	prep_trail() # Preps the MeshInstance3D
	$Control/VBoxContainer/Timeline_Row/HSlider.target_node = $Ion

# Called to find the documents folder path where Safari2 and the .xyz and .traj need to be
func find_doc_path() -> String:
	var documents_path = ""
	
	match OS.get_name():
		"Windows":
			documents_path = OS.get_environment("USERPROFILE") + "/Documents"
		"macOS":
			documents_path = OS.get_environment("HOME") + "/Documents"
		"Linux":
			documents_path = OS.get_environment("HOME") + "/Documents"
		_: # If none of the above
			documents_path = OS.get_environment("HOME") + "/Documents"
	
	var app_folder_path = documents_path + "/Safari2" # The name of the created folder by the py script
	return app_folder_path

# Loads the collision data for the .traj file
func load_collision_data():
	var full_path = find_doc_path() + "/Ion.traj"
	
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file == null:
		# File couldnt open
		emit_signal("no_file")
	else:
		var ion_pos = []
		var ion_mom = []
		var ion_t = []
		
		while file.get_position() < file.get_length():
			var c_line = file.get_line()
			c_arr = c_line.split("\t", false, 0)
			if c_arr[0] == "x":
				pass
			else:
				ion_pos.append([float(c_arr[0]), float(c_arr[2]), float(c_arr[1])])
				ion_mom.append([float(c_arr[3]), float(c_arr[5]), float(c_arr[4])])
				ion_t.append([float(c_arr[6])])
				if file.get_position() == file.get_length():
					ion_val = {
						"position": ion_pos,
						"momentum": ion_mom,
						"time": ion_t
						}
				else:
					pass
		file.close

# Loads the the .xyz file and makes a triple array for them [atom #[time index[x,y,z]]]
func surf_movement():
	var full_path = find_doc_path() + "/Surface.xyz"
	
	var file = FileAccess.open(full_path, FileAccess.READ)
	if file == null:
		# File couldnt open
		print("Error: Couldn't open file at", full_path)
	else: 
		# Considering putting momentum here
		var surf_t = [] # Time of each frame (should line up with traj file)
		var i = 0 # Frame its on (sorta)
		var ind = 0 # Number of surface atom
		var ion_mat = "" # material of ion shot
		var surf_mat = "" # material of surface its hitting
		var num = "" # recurring number at the top of every .xyz file
		
		
		while file.get_position() < file.get_length():
			var c_line = file.get_line()
			c_arr = c_line.split("\t", false, 0 )
			if i == 0:
				if c_arr.size() <= 1:
					emit_signal("no_file")
				else:
					num = String(c_arr[0])
					ion_mat = String(c_arr[1])
					surf_mat = String(c_arr[2])
					i += 1
			else:
				if String(c_arr[0]) == ion_mat or c_arr[0] == num:
					pass
				else:
					if c_arr.size() == 1 and c_arr[0] != num:
						surf_t.append([c_arr[0]])
						i += 1 # Total number of frames
						ind = 0 # resets which atom it's on
					else:
						if ind >= pos.size():
							pos.append([])
						pos[ind].append([float(c_arr[1]), float(c_arr[3]), float(c_arr[2])])
						ind += 1

func prep_trail():
	t_pos = ion_val["position"]

# Updates the trail to the current point that the ion is on
func update_trail(max_point):
	if trail_on == true:
		var im = ImmediateMesh.new()
		trail.mesh = im
		im.clear_surfaces()
		
		if max_point < 1:
			return
		
		im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
		for point in t_pos.slice(0,max_point+1):
			im.surface_add_vertex(Vector3(point[0], point[1], point[2]))
		
		im.surface_end()
	else:
		var im = ImmediateMesh.new()
		trail.mesh = im
		im.clear_surfaces()

func trail_toggled(tbool):
	trail_on = tbool
