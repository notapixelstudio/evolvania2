extends Area2D

func _on_Diamond_body_entered(body):
	if body is Character:
		queue_free()
		
