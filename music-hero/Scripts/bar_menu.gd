extends Node2D

func _ready() -> void:
	$CanvasLayer/SongButtons/Gold/Button.pressed.connect(_on_gold_pressed)
	$CanvasLayer/SongButtons/MrBlue/Button.pressed.connect(_on_blue_pressed)
	$CanvasLayer/SongButtons/Three/Button.pressed.connect(_on_three_pressed)
	$CanvasLayer/BackButton.pressed.connect(_on_back_pressed)


func _on_gold_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/The Black Keys - Gold On The Ceiling [Official Music Video].json"
	Globals.song_path = "res://Songs/MP3/The Black Keys - Gold On The Ceiling [Official Music Video].mp3"
	Globals.note_height = 2
	Globals.song_title = "Gold On The Ceiling - The Black Keys"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_blue_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Mr. Blue Sky by the Electric Light Orchestra (2012 version).json"
	Globals.song_path = "res://Songs/MP3/Mr. Blue Sky by the Electric Light Orchestra (2012 version).mp3"
	Globals.note_height = 2.5
	Globals.song_title = "Mr. Blue Sky - Electric Light Orchestra"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_three_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Bob Marley & The Wailers - Three Little Birds (Official Video).json"
	Globals.song_path = "res://Songs/MP3/Bob Marley & The Wailers - Three Little Birds (Official Video).mp3"
	Globals.note_height = 2.5
	Globals.song_title = "Three Little Birds - Bob Marley"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
