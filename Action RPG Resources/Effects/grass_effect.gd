extends Node2D


@onready var animatedSprite = $AnimatedSprite2D

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")
 


# 애니메이션이 끝나면 큐프리해서 없어지게
func _on_animated_sprite_2d_animation_finished():
	queue_free()
