extends Area2D

class_name Harmful

func _on_Harmful_body_entered(body):
	if body is Character:
		body.harm()
		
