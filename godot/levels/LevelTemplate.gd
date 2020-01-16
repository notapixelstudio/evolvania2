tool
extends Node2D

func _ready():
	$Hero.connect('harmed', self, 'on_hero_harmed')
	refresh()
	
func refresh():
	if $Hero.night_vision:
		$CanvasModulate.color = Color(0,1,0,1)
	else:
		$CanvasModulate.color = Color('#dfbc9a')
	
func on_hero_harmed():
	$HUD/LifeCounter.lose_life(1)
	

func _on_Harmful_body_entered(body):
	pass # Replace with function body.
