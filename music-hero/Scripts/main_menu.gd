extends Node2D

func _ready() -> void:
	$CanvasLayer/Button.pressed.connect(_on_button_pressed)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/instructions_menu.tscn")
