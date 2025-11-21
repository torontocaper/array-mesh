@tool
#@icon
#class_name
extends MeshInstance3D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var grid_size_x : int = 4
@export var grid_size_y : int = 4
@export var threshold : float = 0.5
@export var voronoi_noise : FastNoiseLite = FastNoiseLite.new()
@export var height : float = 5.0
## Regular variables
var vertices = PackedVector3Array()
var colors = PackedColorArray()
## @onready variables

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	#voronoi_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	#voronoi_noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	#voronoi_noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	#voronoi_noise.frequency = noise_frequency
	#draw_mesh()
	pass
	
func _process(delta: float) -> void:
	voronoi_noise.offset.x += delta
	draw_mesh()
	
func draw_mesh() -> void:
	for column in grid_size_x:
		#print_debug("Creating a column of squares in grid position %s" % str(column))
		for row in grid_size_y:
			var noise_value : float = -voronoi_noise.get_noise_2d(column, row)
			#print_debug("Noise value at %s, %s = %s" % [str(column), str(row), str(noise_value)])
			if noise_value > threshold:
				#print_debug("Creating a point at position %s, %s" % [str(column), str(row)])
				vertices.push_back(Vector3(column, 0, row))
				var new_color: Color = Color(noise_value, noise_value, noise_value)
				colors.push_back(new_color)
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arr_mesh.clear_surfaces()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, arrays)
	mesh = arr_mesh

	
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
## Subclasses
