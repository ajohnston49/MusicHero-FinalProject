extends Control

@onready var arrow: ColorRect = $Arrow
@onready var score_label: Label = $ScoreLabel

var globals: Node = null
var last_hit_seen: int = 0

const METER_GREEN_MAX_DEG: float = -10.0
const METER_RED_MAX_DEG: float = -175.0

func _ready() -> void:
	globals = get_node_or_null("/root/Globals")
	last_hit_seen = 0

func _process(_delta: float) -> void:
	if globals == null:
		return

	# Update score and arrow rotation
	score_label.text = str(globals.score)
	arrow.rotation_degrees = clamp(globals.meter_rotation, METER_RED_MAX_DEG, METER_GREEN_MAX_DEG)

	# Optional: react to new hit events (e.g., flash, sound, etc.)
	if globals.hit_event_counter > last_hit_seen:
		# Example: lightweight visual nudge could go here if you want
		# (Left empty on purpose to avoid changing visuals)
		last_hit_seen = globals.hit_event_counter
