extends Node2D

@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var song_title_label: Label = $CanvasLayer/SongTitleLabel

var globals: Node = null

func _ready() -> void:
	globals = get_node_or_null("/root/Globals")
	if globals == null:
		return

	# Connect buttons
	$CanvasLayer/RetryButton.pressed.connect(_on_retry_pressed)
	$CanvasLayer/QuitButton.pressed.connect(_on_quit_pressed)

	# Show the score from this run
	score_label.text = "Score: " + str(globals.score)

	# Show the song title that was set in the menu
	song_title_label.text = globals.song_title

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
