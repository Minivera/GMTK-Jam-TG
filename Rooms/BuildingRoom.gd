extends Control


export (float) var build_amount = false setget _set_build_amount

func _set_build_amount(new_build_amount):
	build_amount = new_build_amount
	$Background/ProgressBar.max_value = new_build_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Background/ProgressBar.value += delta
