extends Node2D


# Declare member variables here. Examples:
signal building_pressed(type)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Headquarters_button_down():
	emit_signal("building_pressed", "headquarters")