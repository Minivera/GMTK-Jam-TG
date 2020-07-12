extends Position2D


# Declare member variables here. Examples:
var held = false
var type = null

onready var globals = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	$DraggingArea.position.x -= globals.cell_size / 2
	$DraggingArea.position.y -= globals.cell_size / 2
	$DraggingArea/CollisionPolygon2D.position.x += globals.cell_size / 2
	$DraggingArea/CollisionPolygon2D.position.y += globals.cell_size / 2


func pickup(type):
	type = type
	held = true;

	for child in $DraggingArea/RoomView.get_children():
		child.queue_free()

	$DraggingArea/RoomView.add_child(globals.get_scene_by_type(type))
	show()


func drop():
	held = false
	hide()


func _physics_process(_delta):
	if held:
		global_transform.origin = get_global_mouse_position()
