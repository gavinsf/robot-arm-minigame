extends Node3D

# Room dimensions (smaller room)
var room_width = 4.0    # Horizontal width
var room_depth = 3.0    # Front-to-back size
var room_height = 2.5   # Vertical height
var wall_thickness = 0.111 # Thickness of the walls

# Uniform scaling factor
var scale_factor = 1.5

func _ready():
	# Scale all dimensions
	var scaled_width = room_width * scale_factor
	var scaled_depth = room_depth * scale_factor
	var scaled_height = room_height * scale_factor
	var scaled_thickness = wall_thickness * scale_factor

	# Floor dimensions
	var floor_width = scaled_width * 10
	var floor_depth = scaled_depth * 10

	# Create the floor
	var floor = create_colored_rectangle(Vector3(floor_width, scaled_thickness, floor_depth), Color(1,0,0)) # Gray
	floor.transform.origin = Vector3(0, -5, 0) # Position the floor at the bottom
	add_child(floor)

	# Create the back wall (matching floor width)
	var back_wall = create_colored_rectangle(Vector3(floor_width, scaled_height*8, scaled_thickness), Color(.6,9,.9)) # Red
	back_wall.transform.origin = Vector3(0, -5, -floor_depth / 2)
	add_child(back_wall)

	# Create the left wall (matching floor depth)
	var left_wall = create_colored_rectangle(Vector3(scaled_thickness, scaled_height*8, floor_depth), Color(0.0, 1.0, 0.0)) # Green
	left_wall.transform.origin = Vector3(-floor_width / 2, -5, 0)
	add_child(left_wall)

	# Create the right wall (matching floor depth)
	var right_wall = create_colored_rectangle(Vector3(scaled_thickness, scaled_height*8, floor_depth), Color(0.0, 0.0, 1.0)) # Blue
	right_wall.transform.origin = Vector3(floor_width / 2, -5, 0)
	add_child(right_wall)

func create_colored_rectangle(size: Vector3, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Half dimensions
	var half_x = size.x / 2
	var half_y = size.y / 2
	var half_z = size.z / 2
	
	# Define vertices for a rectangle (6 faces)
	var vertices = [
		# Front face
		Vector3(-half_x, -half_y, -half_z),
		Vector3(half_x, -half_y, -half_z),
		Vector3(half_x, half_y, -half_z),
		Vector3(-half_x, half_y, -half_z),
		
		# Back face
		Vector3(-half_x, -half_y, half_z),
		Vector3(half_x, -half_y, half_z),
		Vector3(half_x, half_y, half_z),
		Vector3(-half_x, half_y, half_z),
	]
	
	var indices = [
		0, 1, 2, 0, 2, 3, # Front face
		4, 6, 5, 4, 7, 6, # Back face
		0, 3, 7, 0, 7, 4, # Left face
		1, 5, 6, 1, 6, 2, # Right face
		3, 2, 6, 3, 6, 7, # Top face
		0, 4, 5, 0, 5, 1, # Bottom face
	]
	
	for i in indices:
		st.add_vertex(vertices[i])
	
	st.generate_normals()
	var mesh = st.commit()
	mesh_instance.mesh = mesh
	
	# Create a material and set the color
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	mesh_instance.material_override = material
	
	return mesh_instance
