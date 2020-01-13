extends AnimationTree

onready var state_machine = get('parameters/playback')
func travel(name):
	state_machine.travel(name)
	print("Gnacchero")
	
func get_current_state():
	return state_machine.get_current_node()
	