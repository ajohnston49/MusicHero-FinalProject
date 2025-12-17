extends Area2D

@export var lane: int = 1
@export var speed: float = 200.0
@export var hit_zone_y: float = 650.0
@export var lane_width: float = 100.0
@export var note_height: float = 40.0
@export var lane_color: Color = Color.WHITE
@export var duration_ms: int = 0   # >= MIN_TAIL_MS => long note

@onready var body: Polygon2D = $"Body"
@onready var tail: Polygon2D = $"Tail"
@onready var shape: CollisionShape2D = $"Collision"

var globals: Node = null

const MIN_TAIL_MS: int = 300
const HIT_WINDOW_SCALE: float = 1.2
const DESPAWN_OFFSET: float = 200.0

# Meter config (match HUD/game)
const METER_GREEN_MAX_DEG: float = -10.0
const METER_RED_MAX_DEG: float = -175.0
const HIT_STEP_DEG: float = 8.25  # ~5% of range toward green

var is_active: bool = true
var is_missed: bool = false
var holding: bool = false
var tail_length_px: float = 0.0
var tail_length_px_init: float = 0.0

func _ready() -> void:
	globals = get_node_or_null("/root/Globals")

	_draw_head_square()
	_setup_collision()

	if duration_ms >= MIN_TAIL_MS:
		tail_length_px = (duration_ms / 1000.0) * speed
		tail_length_px_init = tail_length_px
		_draw_tail_upward()
	else:
		tail.polygon = PackedVector2Array()

func _process(delta: float) -> void:
	if not is_active:
		return

	position.y += speed * delta

	# Auto‑miss detection
	if duration_ms < MIN_TAIL_MS:
		if not is_missed and position.y >= hit_zone_y + (note_height * 0.2):
			_mark_miss()
	else:
		if not is_missed and not holding and position.y >= hit_zone_y + (note_height * 0.2):
			_mark_miss()

	# Despawn after going far below
	var despawn_limit: float = hit_zone_y + note_height + max(tail_length_px_init, 0.0) + DESPAWN_OFFSET
	if position.y > despawn_limit:
		queue_free()
		return

	var action: String = "lane_" + str(lane)
	var at_hit: bool = abs(position.y - hit_zone_y) < (note_height * HIT_WINDOW_SCALE)

	if duration_ms < MIN_TAIL_MS:
		# Short note: require a TAP, not a hold
		if Input.is_action_just_pressed(action) and at_hit and not is_missed:
			_hit()
	else:
		# Long note: require a TAP to start holding
		if Input.is_action_just_pressed(action) and at_hit and not is_missed and not holding:
			holding = true
			body.visible = false
			shape.disabled = true

		# Continue sustain if holding
		if holding and not is_missed:
			if not Input.is_action_pressed(action):
				_mark_miss()
			else:
				tail_length_px = max(tail_length_px - (speed * delta), 0.0)
				_draw_tail_upward()
				if tail_length_px <= 0.0:
					_hit()

func _draw_head_square() -> void:
	var half_w: float = lane_width * 0.4
	var half_h: float = note_height * 0.5
	body.polygon = PackedVector2Array([
		Vector2(-half_w, -half_h),
		Vector2( half_w, -half_h),
		Vector2( half_w,  half_h),
		Vector2(-half_w,  half_h)
	])
	body.color = lane_color
	body.z_index = 1

func _draw_tail_upward() -> void:
	if tail_length_px <= 0.0:
		tail.polygon = PackedVector2Array()
		return

	var half_tail_w: float = lane_width * 0.25
	var head_half_h: float = note_height * 0.5

	var bottom_y: float = -head_half_h
	var top_y: float = bottom_y - tail_length_px

	var global_bottom: float = position.y + bottom_y
	if not is_missed and global_bottom >= hit_zone_y:
		var offset: float = global_bottom - hit_zone_y
		bottom_y -= offset
		top_y -= offset

	tail.polygon = PackedVector2Array([
		Vector2(-half_tail_w, top_y),
		Vector2( half_tail_w, top_y),
		Vector2( half_tail_w, bottom_y),
		Vector2(-half_tail_w, bottom_y)
	])
	tail.color = lane_color.darkened(0.2)
	tail.z_index = 0

func _setup_collision() -> void:
	var rect := RectangleShape2D.new()
	rect.size = Vector2(lane_width * 0.8, note_height)
	shape.shape = rect
	shape.position = Vector2.ZERO
	shape.disabled = false

func _hit() -> void:
	if globals != null:
		globals.score += 100
		globals.meter_rotation = clamp(globals.meter_rotation + HIT_STEP_DEG, METER_RED_MAX_DEG, METER_GREEN_MAX_DEG)
	is_active = false
	queue_free()

func _mark_miss() -> void:
	if is_missed or not is_active:
		return
	is_missed = true
	if duration_ms < MIN_TAIL_MS:
		body.visible = true
	body.color = Color(0.45, 0.45, 0.45)
	if duration_ms >= MIN_TAIL_MS:
		tail.color = Color(0.35, 0.35, 0.35)
