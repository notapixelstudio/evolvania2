tool
extends KinematicBody2D

class_name Character

var x_speed : float = 800.0
var air_x_speed : float = 800.0
var jump_starting_speed : float = 1400.0
var ascending_gravity_bonus : float = 6200.0
var gravity : float = 8800.0

enum diets {NONE, HERBIVORE, CARNIVORE}

export var horn = false setget set_horn
export (diets) var diet = diets.NONE setget set_diet
export var ears = false setget set_ears
export var pigmy = false setget set_pigmy
export var glowing = false setget set_glowing
export var night_vision = false setget set_night_vision

signal harmed
signal recovered

onready var state_machine = $StateMachine
onready var controls = $Controls
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
		
	state_machine.update(delta)
	velocity = move_and_slide(velocity, Vector2(0,-1)) # second arg is the floor normal, needed by is_on_floor()
	
func apply_gravity(delta):
	velocity += Vector2(0, gravity) * delta
	
func update_horizontal_movement(speed):
	velocity.x = speed * controls.x_dir
	if controls.x_dir != 0:
		$Graphics.scale.x = controls.x_dir
	
func harm():
	state_machine.travel('Stagger')
	