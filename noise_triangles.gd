#@tool
#@icon
#class_name
extends Node2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var field_size : Vector2i = Vector2i(100, 100)
@export var source_noise : FastNoiseLite = FastNoiseLite.new()
@export_range(-1.0, 1.0, 0.1) var target_value : float = 0.0
@export_range(0.0, 1.0, 0.001) var threshold : float = 0.1
## Regular variables
var points_array : PackedVector2Array = []
var triangle_points : PackedVector2Array = []
var triangles_array : PackedInt32Array = []

## @onready variables
@onready var viewport_resolution := Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
#func _draw() -> void:
	#for point_index in triangles_array.size():
		#if triangle_points.size() < 3:
			#triangle_points.append(points_array[triangles_array[point_index]])
		#else: 
			#draw_polygon(triangle_points, PackedColorArray([Color(randf(), randf(), randf())]))
			#triangle_points.clear()

func _ready() -> void:
	scale = viewport_resolution/field_size
	get_noise_points()
	create_triangle_array()
	draw_noise_points()
	draw_triangles()

#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func create_triangle_array() -> void:
	triangles_array = Geometry2D.triangulate_delaunay(points_array)
	print_debug("Triangles array has %s point indices, or %s triangles" % [str(int(triangles_array.size())), str(int(triangles_array.size()/3.0))])

func draw_noise_points() -> void:
	for point in points_array:
		#print_debug("Attempting to draw a sprite at point %s" % str(point))
		var new_sprite := Sprite2D.new()
		new_sprite.texture = preload("uid://sbs86qggfpul")
		new_sprite.position = point
		#new_sprite.centered = false
		new_sprite.scale = Vector2(0.001, 0.001)
		add_child(new_sprite)
		
func draw_triangles() -> void:
	for index in triangles_array:
		#await get_tree().create_timer(1.0).timeout
		#print_debug("Iterating on triangles array; current index is %s" % str(index))
		var index_point = points_array[index]
		print_debug("Adding point %s to current triangle" % index_point)
		triangle_points.append(index_point)
		print_debug("Current triangle has %s points: %s" % [str(triangle_points.size()), str(triangle_points)])
		#print_debug("This index corresponds to the following point: %s" % str(index_point))
		if triangle_points.size() == 3:
			#print_debug("Adding point %s to current triangle" % index_point)
			print_debug("Drawing a triangle with the following points: %s" % str(triangle_points))
			var new_triangle = Polygon2D.new()
			new_triangle.polygon = triangle_points
			new_triangle.color = Color(randf(), randf(), randf())
			add_child(new_triangle)
			triangle_points.clear()
			#triangle_points.append(index_point)
		#else:
			#print_debug("Adding point %s to current triangle" % index_point)
			#triangle_points.append(index_point)
			#print_debug("Current triangle has %s points: %s" % [str(triangle_points.size()), str(triangle_points)])


func get_noise_points() -> void:
	for x in field_size.x: #DisplayServer.window_get_size(0).x:
		for y in field_size.y: #DisplayServer.window_get_size(0).y:
			var noise_value : float = source_noise.get_noise_2d(x, y)
			#print_debug("Noise value at %s, %s is %s" % [str(x), str(y), str(noise_value)])
			if noise_value > target_value - threshold and noise_value < target_value + threshold:
				points_array.append(Vector2(x, y))
	print_debug("Points array has %s points" % points_array.size())
## Subclasses
