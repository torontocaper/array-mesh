@tool
#class_name
extends MeshInstance3D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var grid_size : Vector2i = Vector2i(1, 1)
@export var cell_size : float = 1.0
## Regular variables
## @onready variables

func _ready() -> void:	
	# create the vertices
	#var grid_dimensions : Vector2i = Vector2i(grid_size, grid_size)
	var vertices = PackedVector3Array()
	# create the colors array
	var colors = PackedColorArray()
	for column in grid_size.x:
		#print_debug("Creating a column of squares in grid position %s" % str(column))
		for row in grid_size.y:
			#print_debug("Creating a square in column %s, row %s" % [str(column), str(row)])
			# add the top-left triangle
			vertices.push_back(Vector3(column * cell_size, 0, row * cell_size))
			vertices.push_back(Vector3(column * cell_size + cell_size, 0, row * cell_size))
			vertices.push_back(Vector3(column * cell_size, 0, row * cell_size + cell_size))
			var random_color_tl : Color = Color(randi_range(0, 1), randi_range(0, 1), randi_range(0, 1))
			#print_debug("Creating a top-left triangle using this color: %s" % str(random_color_tl))
			#print_debug()
			for corner in 3:
				colors.push_back(random_color_tl)
			# add the bottom-right triangle
			vertices.push_back(Vector3(column * cell_size + cell_size, 0, row * cell_size))
			vertices.push_back(Vector3(column * cell_size + cell_size, 0, row * cell_size + cell_size))
			vertices.push_back(Vector3(column * cell_size, 0, row * cell_size + cell_size))
			var random_color_br : Color = Color(randi_range(0, 1), randi_range(0, 1), randi_range(0, 1))
			#print_debug("Creating a bottom-right triangle using this color: %s" % str(random_color_br))
			for corner in 3:
				colors.push_back(random_color_br)

	# assign the same color to each vertex in each triangle for solid colors
	#for vertex in vertices.size()/3.0:

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = arr_mesh
	#var surface_array = []
	#surface_array.resize(Mesh.ARRAY_MAX)
#
	## PackedVector**Arrays for mesh construction.
	#var verts = PackedVector3Array()
	#var uvs = PackedVector2Array()
	#var normals = PackedVector3Array()
	#var indices = PackedInt32Array()
#
	########################################
	### Insert code here to generate mesh ##
	########################################
#
	## Assign arrays to surface array.
	#surface_array[Mesh.ARRAY_VERTEX] = verts
	#surface_array[Mesh.ARRAY_TEX_UV] = uvs
	#surface_array[Mesh.ARRAY_NORMAL] = normals
	#surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
## Subclasses
