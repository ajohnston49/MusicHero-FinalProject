
extends Node2D

@onready var light_animation: AnimatedSprite2D = $Buildings/Garage/LightAnimation
@onready var bar_animation: AnimatedSprite2D = $BarSign
@onready var stage_animation: AnimatedSprite2D = $StageSign

# Roadblock collision shapes
@onready var roadblock_collision: CollisionShape2D = $Buildings/Roadblock/Area2D/CollisionShape2D
@onready var roadblock2_collision: CollisionShape2D = $Buildings/Roadblock2/Area2D/CollisionShape2D

# ✅ Music player (2D version)
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
var songs: Array = []
var rng = RandomNumberGenerator.new()
var last_index: int = -1

func _ready() -> void:
	# Play the default animations
	_play_animation(light_animation)
	_play_animation(bar_animation)
	_play_animation(stage_animation)

	# Enable collisions so the player can't walk through
	_enable_collision(roadblock_collision, true)
	_enable_collision(roadblock2_collision, true)

	# ✅ Load songs from folder
	_load_songs()
	_play_random_song()
	music_player.connect("finished", Callable(self, "_on_song_finished"))

# Helpers
func _play_animation(anim: AnimatedSprite2D) -> void:
	if anim != null:
		anim.play()

func _enable_collision(shape: CollisionShape2D, enabled: bool) -> void:
	if shape != null:
		shape.disabled = not enabled

# ✅ Music functions
func _load_songs():
	var dir = DirAccess.open("res://Songs/MP3")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".mp3"):
				var path = "res://Songs/MP3/" + file_name
				songs.append(load(path))
			file_name = dir.get_next()
		dir.list_dir_end()

func _play_random_song():
	if songs.size() == 0:
		return
	var index = rng.randi_range(0, songs.size() - 1)
	# Avoid immediate repeat
	if index == last_index and songs.size() > 1:
		index = (index + 1) % songs.size()
	last_index = index

	music_player.stream = songs[index]
	music_player.play()

func _on_song_finished():
	_play_random_song()
