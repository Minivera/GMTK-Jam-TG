extends Position2D


# Declare member variables here. Examples:
var held = false
var type = null

onready var globals = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func pickup(type):
	type = type
	held = true;
	$DraggingArea/DraggableSprite.set_texture(globals.get_texture_by_type(type))
	show()


func drop():
	held = false
	hide()


func _physics_process(_delta):
	if held:
		global_transform.origin = get_global_mouse_position()
