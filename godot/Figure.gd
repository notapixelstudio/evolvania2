extends Node2D

export var hidden = true

func _ready():
	if hidden:
		modulate = Color(1,1,1,0)
		$Light2D.energy = 0
		
func _on_ShowArea_body_entered(body):
	if hidden and body is Character:
		hidden = false
		$AnimationPlayer.play('Appear')
		
