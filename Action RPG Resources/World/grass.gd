extends Node2D

const GrassEffect = preload("res://Action RPG Resources/Effects/grass_effect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grassEffect = GrassEffect.instantiate()
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		# 애드차일드 했을 때 그 이펙트의 위치를 grass 노드의 글로벌 위치로 변경
		grassEffect.global_position = global_position
		queue_free()
