extends Node2D


# Declare member variables here. Examples:
signal room_pressed(type)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Play sound effect
func _handle_click(type):
	$ClickSfx.play()
	emit_signal("room_pressed", type)

func _on_Computer_button_down():
	_handle_click("headquarters")


func _on_Living_button_down():
	_handle_click("living")


func _on_Farm_button_down():
	_handle_click("farm")


func _on_Reactor_button_down():
	_handle_click("reactor")


func _on_Energy_button_down():
	_handle_click("energy")


func _on_Fabricator_button_down():
	_handle_click("fabricator")


func _on_Laboratory_button_down():
	_handle_click("lab")


func _on_Pump_button_down():
	_handle_click("pump")


func _on_Cryo_button_down():
	_handle_click("cryo")
