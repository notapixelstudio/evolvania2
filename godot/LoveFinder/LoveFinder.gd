extends Control

export var heir: PackedScene

const x_offset_heir = 150

onready var selection = $SelectionHeir
onready var cursor = $Cursor
var selection_index = 0


func _ready():
	set_process_input(false)
	create_heir(1,2)
	var where = selection.get_child(selection_index).global_position
	cursor.global_position = where
	
	
func create_heir(parent1, parent2):
	var n_children = 3+randi()%3 # from 3 to 5
	print("we are going to make ", n_children)
	for i in n_children:
		var child = heir.instance()
		# heir.make_genetics(parent1, parent2)
		selection.add_child(child)
		child.position.x = x_offset_heir*i
	
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		selection_index = max(0, (selection_index-1))
		var where = selection.get_child(selection_index).global_position
		cursor.global_position = where
	if event.is_action_pressed("ui_right"):
		selection_index = min(selection.get_child_count()-1, (selection_index+1))
		var where = selection.get_child(selection_index).global_position
		cursor.global_position = where
