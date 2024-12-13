extends Node3D

@onready var fog = $Fog

var path : Path3D
var pfollow : PathFollow3D
var n : int
var t : float
var pts : PackedVector3Array
var curr : Vector3
var next : Vector3
var forward : Vector3
var skip : int

var speed : float = 0.2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skip = 0
	_setup_path()
	pass 


func _generate_hilbert_curve(order: int, size: float, position: Vector3, points: PackedVector3Array) -> void:
	if order == 0:
		points.append(position)
	else:
		size /= 2.0
		_generate_hilbert_curve(order - 1, size, position + Vector3(-size, 0, -size), points)
		_generate_hilbert_curve(order - 1, size, position + Vector3(-size, 0, size), points)
		_generate_hilbert_curve(order - 1, size, position + Vector3(size, 0, size), points)
		_generate_hilbert_curve(order - 1, size, position + Vector3(size, 0, -size), points)


func _create_catmull_rom_spline(points: PackedVector3Array) -> Curve3D:
	var curve = Curve3D.new()
	n = points.size()
	

	for i in range(n):
		var p0 = points[(i - 1 + n) % n]  # Prev point 
		var p1 = points[i]                # Curr point
		var p2 = points[(i + 1) % n]      # Next point
		var p3 = points[(i + 2) % n]      # point after next

		# Catmull-Rom spline points
		for t in range(0, 460):  # increased the no. of segments between each control point for smoother movement
			var t_normalized = t / 460.0
			var t2 = t_normalized * t_normalized
			var t3 = t2 * t_normalized
		
			var x = 0.5 * ((2.0 * p1.x) + 
						   (-p0.x + p2.x) * t_normalized + 
						   (2.0 * p0.x - 5.0 * p1.x + 4.0 * p2.x - p3.x) * t2 + 
						   (-p0.x + 3.0 * p1.x - 3.0 * p2.x + p3.x) * t3)
			var y = 0.5 * ((2.0 * p1.y) + 
						   (-p0.y + p2.y) * t_normalized + 
						   (2.0 * p0.y - 5.0 * p1.y + 4.0 * p2.y - p3.y) * t2 + 
						   (-p0.y + 3.0 * p1.y - 3.0 * p2.y + p3.y) * t3)
			var z = 0.5 * ((2.0 * p1.z) + 
						   (-p0.z + p2.z) * t_normalized + 
						   (2.0 * p0.z - 5.0 * p1.z + 4.0 * p2.z - p3.z) * t2 + 
						   (-p0.z + 3.0 * p1.z - 3.0 * p2.z + p3.z) * t3)

			curve.add_point(Vector3(x, y, z))
	
	return curve
	
func _setup_path():
	path = Path3D.new()
	path.transform = Transform3D.IDENTITY
	pts = PackedVector3Array()

	var origin = Vector3(8, -115, -80)  # above the game
	var order = 2  # level of recursion for Hilbert curve
	var size = 12.0
	_generate_hilbert_curve(order, size, origin, pts)

	# Creating Catmull-Rom spline from the generated points through hilbert curve
	var curve = _create_catmull_rom_spline(pts)
	path.curve = curve
	pfollow = PathFollow3D.new()
	fog.transform = Transform3D.IDENTITY
	fog.rotate_y(PI)
	fog.reparent(pfollow)
	path.add_child(pfollow)
	pfollow.transform = Transform3D.IDENTITY
	add_child(path)

	_update_path_mesh()

	
func _update_path_mesh():
	var curve = _create_catmull_rom_spline(pts)
	var points = curve.get_baked_points()
	
	var mesh = ArrayMesh.new()
	var surface_arrays = []  
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()

	for i in range(points.size() - 1):
		vertices.append(points[i])
		vertices.append(points[i + 1])
		var index_start = i * 2
		indices.append(index_start)
		indices.append(index_start + 1)

	surface_arrays.resize(Mesh.ARRAY_MAX)
	surface_arrays[Mesh.ARRAY_VERTEX] = vertices
	surface_arrays[Mesh.ARRAY_INDEX] = indices

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_arrays)
	#path_mesh.mesh = mesh  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Updating time based on speed
	t = (t + delta * speed) if (t < 10) else 0
	pfollow.progress_ratio = t / 10.0

	#clouds.transform.basis = Basis(Vector3(0, 1, 0), PI) * Transform3D.IDENTITY.basis  # Rotate about y-axis by 180 degrees
	#clouds.transform.basis=Basis(Vector3(0, 1, 0), PI) *Basis(Vector3(0, 0, 1),sin(t * 2 * PI / 5) * -PI / 8.0)* clouds.transform.basis
	pass
