extends Sprite2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		queue_free()
