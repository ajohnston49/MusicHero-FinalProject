extends Control

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Ensure the animation loops and plays
	if anim_sprite:
		anim_sprite.play()              # plays the default animation
