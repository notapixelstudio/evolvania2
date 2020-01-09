extends Area2D

export var to_level : String

func _on_Exit_body_entered(body):
	if body is Character:
		body.queue_free()
		get_tree().change_scene(to_level)
		