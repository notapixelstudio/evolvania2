extends AnimationTree

export var starting_state : String = 'Idle'

onready var state_machine = get('parameters/playback')
var old_state

signal transition

func _ready():
	var new_node = get_node(starting_state)
	if new_node:
		new_node.enter(old_state)
		
	old_state = starting_state

func travel(state):
	state_machine.travel(state)
	
	# signal whenever there is a status transition
	if state != old_state:
		emit_signal('transition', old_state, state)
		
		if old_state:
			var old_node = get_node(old_state)
			if old_node:
				old_node.exit(state)
			
		var new_node = get_node(state)
		if new_node:
			new_node.enter(old_state)
			
		old_state = state
	
func get_current_state():
	return state_machine.get_current_node()
	
func update_current_state(delta):
	var state = get_current_state()
	if not state:
		return
		
	var state_node = get_node(state)
	if not state_node:
		return
		
	state_node.update(delta)
	