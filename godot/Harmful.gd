extends Area2D

func _on_Harmful_body_entered(body):
	if body is Character:
		body.harm()
		
