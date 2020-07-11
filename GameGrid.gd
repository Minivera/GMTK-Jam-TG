extends Node2D


# Declare member variables here. Examples:
const rows = 15
const cols = 5

const scroll_speed = 2

onready var globals = get_node("/root/Globals")

var max_scroll
var motion = Vector2()
const still = Vector2(0, 0)

# Keep a reference to all the rooms
var rooms = []
var hovered = null
signal room_created(object)

onready var Room = preload("res://Room.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var cell_size = globals.cell_size
	var margin_size = globals.margin_size
	
	for i in range(rows):
		for j in range(cols):
			var room = Room.instance()
			room.offset = {
				"x": cell_size * j + margin_size * j,
				"y": cell_size * i + margin_size * i
			}
			room.grid_position = Vector2(j, i)
			room.size = Vector2(cell_size, cell_size)
			room.texture = globals.empty_texture
			room.type = "empty"
			room.connect("room_entered", self, "_on_room_entered")
			rooms.append(room)
			$Position2D/Camera2D.add_child(room)
	
	$Position2D/Camera2D.set_limit(MARGIN_TOP, 0)
	$Position2D/Camera2D.set_limit(MARGIN_BOTTOM, cell_size * rows + margin_size * rows)
	max_scroll = cell_size * rows + margin_size * rows


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			motion = Vector2(0, scroll_speed)
		if event.button_index == BUTTON_WHEEL_UP:
			motion = Vector2(0, -scroll_speed)

func _physics_process(delta):
	var speed = 256 * delta
	if motion.abs() != still:
		$Position2D.translate(-motion * speed)
		motion = still


func _on_room_entered(room):
	hovered = room


func _verify_room_creation():
	pass

func drop():
	if hovered && globals.holding_room != "empty":
		hovered.type = globals.holding_room
		hovered.texture = globals.get_texture_by_type(hovered.type)
		hovered = null
