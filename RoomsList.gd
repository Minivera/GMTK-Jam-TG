extends Node2D


# Declare member variables here. Examples:
signal room_pressed(type)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Computer_button_down():
	_handle_click("headquarters")

func _on_Pod_button_down():
	_handle_click("living")

# Play sound effect
func _handle_click(type):
	$ClickSfx.play()
	emit_signal("room_pressed", type)
