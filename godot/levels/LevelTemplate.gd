extends Node2D

func _ready():
	$Hero.connect('harmed', self, 'on_hero_harmed')
	
func on_hero_harmed():
	$HUD/LifeCounter.lose_life(1)
	