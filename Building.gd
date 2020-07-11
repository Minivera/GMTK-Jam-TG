extends Node2D


# Declare member variables here. Examples:
export ({}) var offset


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.offset.x = offset["x"]
	$Sprite.offset.y = offset["y"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
