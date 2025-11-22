#@tool
#@icon
#class_name
extends Node2D
## Class for generating a point cloud and connecting via Delaungay triangles

## Signals
## Enums
## Constants

## @export variables
@export var palette : ColorPalette
@export var field_size : Vector2i = Vector2i(128, 72)
@export var source_noise : FastNoiseLite = FastNoiseLite.new()
@export var star_scale : float = 0.01
@export_range(-1.0, 1.0, 0.1) var target_value : float = -0.5
@export_range(0.0, 1.0, 0.001) var threshold : float = 0.01

## Regular variables
var points_array : PackedVector2Array = []
var triangle_points : PackedVector2Array = []
var triangle_indices : PackedInt32Array = []

## @onready variables
@onready var viewport_resolution := Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
@onready var star_polygon = load("res://star_polygon.tscn")

## Overridden built-in virtual methods
func _ready() -> void:
	scale = viewport_resolution/field_size
	source_noise.seed = randi()
	get_noise_points()
	create_triangle_array()
	draw_noise_points()
	draw_triangles()

## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func create_triangle_array() -> void:
	triangle_indices = Geometry2D.triangulate_delaunay(points_array)

func draw_noise_points() -> void:
	for point in points_array:
		var new_star = star_polygon.instantiate()
		#new_star.texture = preload("uid://sbs86qggfpul")
		new_star.position = point
		new_star.z_index = 10
		new_star.scale = randf_range(0.1, 3.0) * Vector2(star_scale, star_scale)
		add_child(new_star)

func draw_triangles() -> void:
	for index in triangle_indices:
		var index_point = points_array[index]
		triangle_points.append(index_point)
		if triangle_points.size() == 3:
			if randi_range(0, 7) == 1:
				await get_tree().create_timer(0.01).timeout
				#var new_triangle = Polygon2D.new()
				var new_triangle = Line2D.new()
				#new_triangle.polygon = triangle_points
				new_triangle.points = triangle_points
				#new_triangle.color = palette.colors.get(randi_range(0, palette.colors.size() -1))
				new_triangle.default_color = palette.colors.get(randi_range(0, palette.colors.size() -1))
				#new_triangle.color.a = randf_range(0.1, 1.0)
				new_triangle.width = 0.1
				add_child(new_triangle)
			triangle_points.clear()

func get_noise_points() -> void:
	for x in field_size.x: 
		for y in field_size.y:
			var noise_value : float = source_noise.get_noise_2d(x, y)
			if noise_value > target_value - threshold and noise_value < target_value + threshold:
				points_array.append(Vector2(x, y))
	print_debug("Points array has %s points" % points_array.size())
## Subclasses
