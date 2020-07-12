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
	emit_signal("room_pressed", "computer")


func _on_Pod_button_down():
	emit_signal("room_pressed", "pod")
