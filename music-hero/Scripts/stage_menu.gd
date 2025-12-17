extends Node2D

func _ready() -> void:
	$CanvasLayer/SongButtons/Hearts/Button.pressed.connect(_on_hearts_pressed)
	$CanvasLayer/SongButtons/Andy/Button.pressed.connect(_on_andy_pressed)
	$CanvasLayer/SongButtons/IRan/Button.pressed.connect(_on_ran_pressed)
	$CanvasLayer/SongButtons/Destruction/Button.pressed.connect(_on_destroy_pressed)
	$CanvasLayer/BackButton.pressed.connect(_on_back_pressed)


func _on_hearts_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Bullet For My Valentine - Hearts Burst Into Fire (Official Video).json"
	Globals.song_path = "res://Songs/MP3/Bullet For My Valentine - Hearts Burst Into Fire (Official Video).mp3"
	Globals.note_height = 2.5
	Globals.song_title = "Hearts Burst Into Fire\nBullet For My Valentine"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_andy_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Andy James - After Midnight (Playthrough).json"
	Globals.song_path = "res://Songs/MP3/Andy James - After Midnight (Playthrough).mp3"
	Globals.note_height = 2.5
	Globals.song_title = "After Midnight - Andy James"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_ran_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/A Flock Of Seagulls - I Ran (So Far Away) (Video).json"
	Globals.song_path = "res://Songs/MP3/A Flock Of Seagulls - I Ran (So Far Away) (Video).mp3"
	Globals.note_height = 2.8
	Globals.song_title = "I Ran (So Far Away)\nA Flock Of Seagulls"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_destroy_pressed() -> void:
	Globals.chart_path = "res://Songs/JSON/Joywave Destruction Lyrics.json"
	Globals.song_path = "res://Songs/MP3/Joywave Destruction Lyrics.mp3"
	Globals.note_height = 2.5
	Globals.song_title = "Destruction - Joywave"
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
