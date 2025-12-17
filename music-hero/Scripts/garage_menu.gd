extends Node2D

func _ready() -> void:
	$CanvasLayer/SongButtons/NothingElseMatters/Button.pressed.connect(_on_nothingelsematters_pressed)
	$CanvasLayer/SongButtons/Riptide/Button.pressed.connect(_on_rip_pressed)
	$CanvasLayer/SongButtons/Shine/Button.pressed.connect(_on_shine_pressed)
	$CanvasLayer/BackButton.pressed.connect(_on_back_pressed)


func _on_nothingelsematters_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Metallica_ Nothing Else Matters (Official Music Video).json"
	Globals.song_path = "res://Songs/MP3/Metallica_ Nothing Else Matters (Official Music Video).mp3"
	Globals.note_height = 1.8
	Globals.song_title = "Nothing Else Matters - Metallica"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_shine_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Collective Soul - Shine (Official Video).json"
	Globals.song_path = "res://Songs/MP3/Collective Soul - Shine (Official Video).mp3"
	Globals.note_height = 2
	Globals.song_title = "Shine - Collective Soul"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_rip_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Sick Puppies - Riptide.json"
	Globals.song_path = "res://Songs/MP3/Sick Puppies - Riptide.mp3"
	Globals.note_height = 1.9
	Globals.song_title = "Riptide - Sick Puppies"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
