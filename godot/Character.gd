tool
extends KinematicBody2D

class_name Character

export var x_speed : float = 800.0
export var air_x_speed: float = 550.0
export var jump_speed: float = 1500.0
export var jump_gravity : float = 3000.0
export var gravity : float = 7800.0

enum diets {NONE, HERBIVORE, CARNIVORE}

export var horn = false setget set_horn
export (diets) var diet = diets.NONE setget set_diet
export var ears = false setget set_ears
export var pigmy = false setget set_pigmy
export var glowing = false setget set_glowing
export var night_vision = false setget set_night_vision

signal harmed
signal recovered

onready var state_machine = $AnimationTree.get('parameters/playback')
onready var last_safe_position : Vector2 = position


var old_state = null
var velocity : Vector2 = Vector2(0,0)


func _ready():
	$Graphics/Head/eyes.playing = true
	$Graphics/Head/eyes_spider.playing = true
	refresh()
	
func set_horn(value):
	horn = value
	refresh()
	
func set_ears(value):
	ears = value
	refresh()
	
func set_diet(value):
	diet = value
	refresh()
	
func set_pigmy(value):
	pigmy = value
	refresh()
	
func set_glowing(value):
	glowing = value
	refresh()
	
func set_night_vision(value):
	night_vision = value
	refresh()
	
func refresh():
	$Graphics/Head/Top/horn.visible = horn
	$Graphics/Head/Top/ears.visible = ears
	$Graphics/glow.visible = glowing
	$Graphics/Head/eyes_spider.visible = night_vision
	
	if pigmy:
		scale = Vector2(0.8,0.8)
		$Graphics/Head/head.visible = false
		$Graphics/Head/head_pigmy.visible = true
		$Graphics/Head/Top.position.y = 40
	else:
		scale = Vector2(1,1)
		$Graphics/Head/head.visible = true
		$Graphics/Head/head_pigmy.visible = false
		$Graphics/Head/Top.position.y = 0
		
	$Graphics/Head/mouth.visible = false
	$Graphics/Head/mouth_herbivore.visible = false
	$Graphics/Head/mouth_carnivore.visible = false
	if diet == diets.NONE:
		$Graphics/Head/mouth.visible = true
	elif diet == diets.HERBIVORE:
		$Graphics/Head/mouth_herbivore.visible = true
	elif diet == diets.CARNIVORE:
		$Graphics/Head/mouth_carnivore.visible = true
		
	if Engine.is_editor_hint():
		get_parent().refresh()
	
func _process(delta):
	if Engine.is_editor_hint():
		return
	
	# use the animation state machine for gameplay purposes too
	var current_state = state_machine.get_current_node()
	
	# read controls
	var x_dir = $Controls.x_dir if has_node('Controls') else 0
	var jump_just_requested = $Controls.jump_just_requested if has_node('Controls') else false
	var jump_just_released = $Controls.jump_just_released if has_node('Controls') else false
	
	### running on a platform
	# start
	if current_state == 'Idle' and x_dir != 0:
		state_machine.travel('Running')
		
	# stop
	if current_state == 'Running' and x_dir == 0:
		state_machine.travel('Idle')
		
	### jumping from a platform
	if (current_state == 'Idle' or current_state == 'Running') and jump_just_requested:
		state_machine.travel('Jumping')
	
	### falling
	if current_state != 'Falling' and velocity.y > 0:
		state_machine.travel('Falling')
		
	# controllable height of jump
	if current_state == 'Jumping' and jump_just_released:
		state_machine.travel('Falling')
		
	### landing
	if current_state == 'Falling' and is_on_floor():
		state_machine.travel('Idle')
		
		
	### horizontal movement
	if current_state == 'Jumping' or current_state == 'Falling':
		velocity.x = air_x_speed * x_dir
	elif current_state == 'Running':
		velocity.x = x_speed * x_dir
		
	# flipping
	if current_state != 'Stagger' and x_dir != 0:
		$Graphics.scale.x = x_dir
	
	### gravity
	if current_state == 'Jumping':
		velocity.y += jump_gravity * delta
	elif current_state != 'Stagger':
		velocity.y += gravity * delta
		
	### Stagger
	if current_state == 'Stagger':
		velocity = Vector2(0,0)
		
	
	velocity = move_and_slide(velocity, Vector2(0,-1)) # second arg is the floor normal, needed by is_on_floor()
	
	
	# call whenever there is a status transition
	if current_state != old_state:
		_on_state_changed(old_state, current_state)
		old_state = current_state
		
func _on_state_changed(old_name, new_name):
	# log status change
	print(old_name, ' -> ', new_name)
	
	if new_name == 'Jumping':
		velocity.y = -jump_speed
		
	if old_name == 'Idle':
		last_safe_position = position
		
	if new_name == 'Stagger':
		emit_signal('harmed')
		
	if old_name == 'Stagger':
		emit_signal('recovered')
		position = last_safe_position
		
func harm():
	state_machine.travel('Stagger')
	