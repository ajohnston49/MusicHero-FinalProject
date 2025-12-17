extends Node2D

func _ready() -> void:
	$CanvasLayer/Button.pressed.connect(_on_button_pressed)
	$CanvasLayer/AnimatedSprite2D.play("default")
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
