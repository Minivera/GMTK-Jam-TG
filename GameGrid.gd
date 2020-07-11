extends Node2D


# Declare member variables here. Examples:
const rows = 15
const cols = 5

const cell_size = 32
const margin_size = 12
const scroll_speed = 2

var max_scroll
var motion = Vector2()
const still = Vector2(0, 0)

# Keep a reference to all the buildings
var buildings = []

export (PackedScene) var Building

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(rows):
		for j in range(cols):
			var building = Building.instance()
			building.offset = {
				"x": cell_size * j + margin_size * j,
				"y": cell_size * i + margin_size * i
			}
			buildings.append(building)
			$Position2D/Camera2D.add_child(building)
	
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
