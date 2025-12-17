extends Node2D

var chart_path: String = "res://Songs/JSON/Andy James - After Midnight (Playthrough).json"
var song_path: String = "res://Songs/MP3/Andy James - After Midnight (Playthrough).mp3"

@export var note_scene: PackedScene
@export var fall_time: float = 2.0
@export var lanes: int = 4

var chart: Array[Dictionary] = []
var start_ticks: int = 0
var lane_centers: Array[float] = []
var hit_zone_y: float = 0.0
var speed_px_per_sec: float = 0.0
var lane_width: float = 0.0
var note_height: float = 0.0

# Meter configuration
const METER_START_DEG: float = -90.0
const METER_GREEN_MAX_DEG: float = -10.0
const METER_RED_MAX_DEG: float = -175.0

# Step sizes
const MISS_STEP_DEG: float = 16.5   # ~10% of range toward red

@onready var notes_container: Node2D = $Notes
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var ghost_miss_player: AudioStreamPlayer2D = $GhostMissPlayer   # <-- miss sound player

@onready var track_container: Control = get_node_or_null("../TrackContainer") as Control
@onready var trigger: Area2D = get_node_or_null("../Trigger") as Area2D
@onready var missed_zone: Area2D = get_node_or_null("../MissedZone") as Area2D

var globals: Node = null

func _ready() -> void:
	globals = get_node_or_null("/root/Globals")
	if globals != null:
		globals.meter_rotation = METER_START_DEG
		globals.score = 0
		globals.hit_event_counter = 0

		if globals.chart_path != "":
			chart_path = globals.chart_path
		if globals.song_path != "":
			song_path = globals.song_path
		if globals.note_height != 0.0:
			note_height = globals.note_height

	if track_container == null:
		push_error("Game: TrackContainer not found as sibling of Game.")
		return

	var width: float = track_container.size.x
	var height: float = track_container.size.y

	lane_width = width / float(lanes)


	hit_zone_y = height - (height * 0.08)
	speed_px_per_sec = height / fall_time

	lane_centers.clear()
	for i in range(lanes):
		lane_centers.append(lane_width * (float(i) + 0.5))

	if trigger != null:
		trigger.position.y = hit_zone_y
		if not trigger.is_connected("area_entered", Callable(self, "_on_trigger_area_entered")):
			trigger.area_entered.connect(_on_trigger_area_entered)

	if missed_zone != null:
		missed_zone.position.y = hit_zone_y
		if not missed_zone.is_connected("area_entered", Callable(self, "_on_missed_zone_area_entered")):
			missed_zone.area_entered.connect(_on_missed_zone_area_entered)

	var f := FileAccess.open(chart_path, FileAccess.READ)
	if f != null:
		var parsed: Variant = JSON.parse_string(f.get_as_text())
		f.close()
		if typeof(parsed) == TYPE_ARRAY:
			chart.clear()
			for item in (parsed as Array):
				if typeof(item) == TYPE_DICTIONARY:
					chart.append(item as Dictionary)

	if chart.is_empty():
		chart = [
			{"time": 800, "lane": 1},
			{"time": 1600, "lane": 2, "duration": 1200},
			{"time": 2400, "lane": 3},
			{"time": 3200, "lane": 4, "duration": 800}
		]

	chart.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("time", 0)) < int(b.get("time", 0))
	)

	var audio_stream: AudioStream = load(song_path) as AudioStream
	if audio_stream != null and audio != null:
		audio.stream = audio_stream
		audio.play()
		audio.finished.connect(_on_song_finished)

	# Adjust ghost miss sound volume + pitch
	if ghost_miss_player != null:
		ghost_miss_player.volume_db = -6.0   # quieter
		ghost_miss_player.pitch_scale = 1.3  # slightly faster

	start_ticks = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var song_ms: int = Time.get_ticks_msec() - start_ticks
	var lead_ms: int = int(fall_time * 1000.0)

	# Spawn notes
	for i in range(chart.size()):
		var n := chart[i]
		var t_ms: int = int(n.get("time", 0))
		if not n.has("spawned") and song_ms >= t_ms - lead_ms:
			_spawn_note(n)
			n["spawned"] = true
			chart[i] = n

	# --- Ghost input detection with forgiveness ---
	for lane in range(lanes):
		var action: String = "lane_" + str(lane + 1)
		if Input.is_action_just_pressed(action):
			var found_note: bool = false
			for note in notes_container.get_children():
				if note.lane == lane + 1 and not note.is_missed:
					# Expanded forgiveness window (2.5x note height instead of 1.2x)
					var at_hit: bool = abs(note.position.y - hit_zone_y) < (note.note_height * 2.5)
					if at_hit:
						found_note = true
						break
			if not found_note:
				# Ghost miss only if no note is even close
				globals.meter_rotation = clamp(globals.meter_rotation - MISS_STEP_DEG, METER_RED_MAX_DEG, METER_GREEN_MAX_DEG)

				if ghost_miss_player != null:
					ghost_miss_player.play()

				if globals.meter_rotation <= METER_RED_MAX_DEG:
					get_tree().change_scene_to_file("res://Scenes/lose_menu.tscn")

func _spawn_note(n: Dictionary) -> void:
	if note_scene == null:
		push_error("Note scene not assigned in Inspector!")
		return
	if notes_container == null:
		push_error("Game: 'Notes' container not found.")
		return

	var lane: int = clamp(int(n.get("lane", 1)), 1, lanes)
	var inst := note_scene.instantiate() as Area2D

	inst.set("lane", lane)
	inst.set("speed", speed_px_per_sec)
	inst.set("hit_zone_y", hit_zone_y)
	inst.set("lane_width", lane_width)
	inst.set("note_height", note_height)
	inst.set("lane_color", _lane_color(lane))
	inst.set("duration_ms", int(n.get("duration", 0)))
	inst.set("is_held", false)

	var x: float = lane_centers[lane - 1]
	inst.position = Vector2(x, -note_height)

	notes_container.add_child(inst)

func _on_trigger_area_entered(area: Area2D) -> void:
	# Only flag sustains as held when crossing the trigger
	if area.has_method("set") and area.get("duration_ms") > 0:
		area.set("is_held", true)

func _on_missed_zone_area_entered(area: Area2D) -> void:
	if area.has_method("_mark_miss"):
		# Skip if sustain still held
		if area.get("duration_ms") > 0 and area.get("is_held"):
			return
		area.call("_mark_miss")
		# Rotate toward red
		globals.meter_rotation = clamp(globals.meter_rotation - MISS_STEP_DEG, METER_RED_MAX_DEG, METER_GREEN_MAX_DEG)

		if ghost_miss_player != null:
			ghost_miss_player.play()

		if globals.meter_rotation <= METER_RED_MAX_DEG:
			get_tree().change_scene_to_file("res://Scenes/lose_menu.tscn")

func _on_song_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

func _lane_color(lane: int) -> Color:
	match lane:
		1: return Color(1, 0, 0)
		2: return Color(0, 0.4, 1)
		3: return Color(0, 0.85, 0)
		4: return Color(1, 0.85, 0)
		_: return Color(1, 1, 1)
