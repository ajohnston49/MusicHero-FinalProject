extends Node

var chart_path: String = ""
var song_path: String = ""
var note_height: float = 0.0
var song_title: String = ""
# HUD globals
var score: int = 0
var meter_rotation: float = -90.0

# New: increments on every successful note hit (disappears)
var hit_event_counter: int = 0
var note_count: int = 0
