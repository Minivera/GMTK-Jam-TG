extends Position2D


export(Texture) var headquarters_texture

# Declare member variables here. Examples:
var held = false
var type = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func pickup(type):
	type = type
	held = true;
	if type == "headquarters":
		$DraggableSprite.set_texture(headquarters_texture)
		show()


func drop():
	held = false
	hide()


func _physics_process(_delta):
	if held:
		global_transform.origin = get_global_mouse_position()
