extends KinematicBody2D

export var health : int = 4
export var direction : int = -1
export var speed : float = 400.0

export var gravity : float = 8000.0

var velocity : Vector2 = Vector2(0,0)

func _ready():
	set_process(false)

func _on_HarmfulArea_body_entered(body):
	if body is Character:
		body.harm()
		
func damage(amount, direction):
	health -= amount
	velocity.x += 5000.0 * direction
	
	if health <= 0:
		queue_free()
		
		
func _process(delta):
	if is_on_wall():
		direction *= -1
		
	velocity.x += speed * direction
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	velocity.x = 0
	
func _on_screen_entered():
	set_process(true)
	
func _on_screen_exited():
	set_process(false)
	
