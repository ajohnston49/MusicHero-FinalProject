extends Node2D

func _ready() -> void:
	$CanvasLayer/SongButtons/One/Button.pressed.connect(_on_one_pressed)
	$CanvasLayer/SongButtons/OAngel/Button.pressed.connect(_on_0Angel_pressed)
	$CanvasLayer/BackButton.pressed.connect(_on_back_pressed)


func _on_one_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Finger Eleven - One Thing (Official Music Video).json"
	Globals.song_path = "res://Songs/MP3/Finger Eleven - One Thing (Official Music Video).mp3"
	Globals.note_height = 2.5
	Globals.song_title = "One Thing - Finger Eleven"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_0Angel_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Mr.Kitty - 0% Angel.json"
	Globals.song_path = "res://Songs/MP3/Mr.Kitty - 0% Angel.mp3"
	Globals.note_height = 2.5
	Globals.song_title = "0% Angel - Mr.Kitty"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
