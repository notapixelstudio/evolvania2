extends Node2D


func _ready():
	$Character/Controls.set_process(false)
	$Character/Controls.set_process_input(false)
	
