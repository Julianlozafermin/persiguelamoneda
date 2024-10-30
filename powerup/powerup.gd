extends Area2D

func _ready():
	$InicioTimer.wait_time = randf_range(.3,.8)
	$InicioTimer.start()




func recoger():
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2d,"scale", Vector2(.1,.1),.2)
	var tween2 = create_tween()
	tween2.tween_property($AnimatedSprite2d, "modulate", Color.RED, .2)
	tween.finished.connect(eliminar)

func eliminar():
	queue_free()



func _on_inicio_timer_timeout():
	$AnimatedSprite2d.frame=0
#	$AnimatedSprite2d.playing = true
	


func _on_life_timer_timeout():
	eliminar()


func _on_powerup_area_entered(area):
	if area.is_in_group("enemigos"):
		position = Vector2(randf_range(0,get_parent().screensize.x) , randf_range(0,get_parent().screensize.y))

