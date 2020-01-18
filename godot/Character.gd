tool
extends KinematicBody2D

class_name Character

var x_speed : float = 1000.0
var air_x_speed : float = 1000.0
var jump_starting_speed : float = 1600.0
var ascending_gravity_bonus : float = 5800.0
var gravity : float = 9000.0
var max_fall_speed : float = 2800.0

enum horns {NONE, NORMAL, GOD}
enum diets {NONE, HERBIVORE, CARNIVORE}

export (horns) var horn = horns.NONE setget set_horn
export (diets) var diet = diets.NONE setget set_diet
export var ears = false setget set_ears
export var pigmy = false setget set_pigmy
export var glowing = false setget set_glowing
export var night_vision = false setget set_night_vision

signal harmed
signal recovered

onready var state_machine = $StateMachine
onready var controls = $Controls
onready var safe_position = position

var old_state = null
var velocity : Vector2 = Vector2(0,0)
var last_wall : int = 0

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
	$Graphics/Head/Top/horn.visible = horn == horns.NORMAL
	$Graphics/Head/Top/horn_god.visible = horn == horns.GOD
	$Graphics/Head/Top/HitArea/CollisionShape2D.disabled = horn == horns.NONE
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
		
	state_machine.update(delta)
	velocity = move_and_slide(velocity, Vector2(0,-1)) # second arg is the floor normal, needed by is_on_floor()
	last_wall = get_which_wall_collided()
	
func apply_gravity(delta):
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
func update_horizontal_movement(speed):
	velocity.x = speed * controls.x_dir
	update_flip()
	
func update_flip():
	if controls.x_dir != 0:
		$Graphics.scale.x = controls.x_dir
	
func harm():
	state_machine.travel('Stagger')
	
func slash():
	for body in $Graphics/SlashArea.get_overlapping_bodies():
		if body is Destructible:
			body.damage(2)
	
func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return last_wall
	
var debug_states = []
func _on_StateMachine_transition(old, new):
	debug_states.append(new)
	if len(debug_states) > 6:
		debug_states.pop_front()
		
	$StateDebug.text = ''
	for state in debug_states:
		$StateDebug.text += '\n' + state
	
func _on_HitArea_body_entered(body):
	if body is Destructible:
		if horn == horns.NORMAL:
			body.damage(2)
		elif horn == horns.GOD:
			body.damage(6)
			
