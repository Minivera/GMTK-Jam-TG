extends Node2D


onready var globals = get_node("/root/Globals")
export (String) var shape

var local_shape = null
var shape_counter = 0

onready var Room = preload("res://Room.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	local_shape = globals.get_building(shape)
	
	$ShapeName.set_text(local_shape["name"])
	$Timer.start()
	_render_shape()


func _render_shape():
	var cell_size = globals.cell_size
	var margin_size = globals.margin_size

	# Remove all children
	for child in $ShapeContainer.get_children():
		child.queue_free()
	
	# Get the current shape
	var current_shape = local_shape["shapes"][shape_counter]
	
	# Iterate on each of the cells of the shape we describe in the shapes array
	for i in range(current_shape.size()):
		for j in range(current_shape[i].size()):
			var shape_element = current_shape[i][j]
			
			# Skip any nulls
			if shape_element == null:
				continue
			
			var room = Room.instance()
			room.offset = {
				"x": cell_size * j + margin_size * j,
				"y": cell_size * i + margin_size * i
			}
			room.grid_position = Vector2(j, i)
			room.size = Vector2(cell_size, cell_size)
			room.texture = globals.get_texture_by_type(shape_element)
			room.type = shape_element
			$ShapeContainer.add_child(room)


func _on_Timer_timeout():
	shape_counter += 1
	# Change which shape we display whenever the time times out
	if shape_counter >= local_shape["shapes"].size():
		shape_counter = 0;
	
	_render_shape()
