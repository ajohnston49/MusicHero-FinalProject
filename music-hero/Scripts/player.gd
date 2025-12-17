extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_prompt: Sprite2D = $InteractPrompt   # overhead prompt sprite

var in_trailer_area: bool = false
var in_bar_area: bool = false
var in_garage_area: bool = false
var in_stage_area: bool = false
var in_yellow_chat_area: bool = false
var in_green_chat_area: bool = false
var in_blue_chat_area: bool = false

# Chat bubble toggle
@onready var chat_bubble: CanvasLayer = get_tree().current_scene.get_node("ChatBubble")
var chat_visible: bool = false

func _ready() -> void:
	# Start with prompt hidden
	interact_prompt.visible = false

func _physics_process(delta: float) -> void:
	var input_dir: float = 0.0
	
	if Input.is_action_pressed("move_left"):
		input_dir += 1
	if Input.is_action_pressed("move_right"):
		input_dir -= 1

	velocity.x = input_dir * speed

	if input_dir == 0:
		anim_sprite.play("idle")
	else:
		anim_sprite.play("run")
		anim_sprite.flip_h = input_dir < 0

	move_and_slide()

	# Handle interaction
	if in_bar_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/bar_menu.tscn")
		
	if in_trailer_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/trailer_menu.tscn")
		
	if in_garage_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/garage_menu.tscn")
		
	if in_stage_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/stage_menu.tscn")
		
	# Yellow chat toggle
	if in_yellow_chat_area and Input.is_action_just_pressed("interact"):
		if chat_visible:
			chat_bubble.visible = false
			chat_visible = false
		else:
			show_chat_bubble()
		
	if in_green_chat_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/trailer_menu.tscn")
	
	if in_blue_chat_area and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://Scenes/trailer_menu.tscn")


# Chat Bubble Handling
func show_chat_bubble() -> void:
	chat_bubble.visible = true

	# Play yellow animation
	var bubble_anim: AnimatedSprite2D = chat_bubble.get_node("ChatSprite")
	bubble_anim.play("Yellow")

	# Randomly pick one of the labels
	var labels: Array = [
		chat_bubble.get_node("YellowChat/ChatLabel_one"),
		chat_bubble.get_node("YellowChat/ChatLabel_two"),
		chat_bubble.get_node("YellowChat/ChatLabel_three")
	]

	for l in labels:
		l.visible = false

	var random_label = labels[randi() % labels.size()]
	random_label.visible = true

	chat_visible = true


# --- Area signals with prompt toggle ---
func _on_trailer_area_body_entered(body: Node) -> void:
	if body == self:
		in_trailer_area = true
		interact_prompt.visible = true

func _on_trailer_area_body_exited(body: Node) -> void:
	if body == self:
		in_trailer_area = false
		interact_prompt.visible = false

func _on_garage_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_garage_area = true
		interact_prompt.visible = true

func _on_garage_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_garage_area = false
		interact_prompt.visible = false

func _on_bar_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_bar_area = true
		interact_prompt.visible = true

func _on_bar_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_bar_area = false
		interact_prompt.visible = false

func _on_stage_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_stage_area = true
		interact_prompt.visible = true

func _on_stage_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_stage_area = false
		interact_prompt.visible = false

func _on_yellow_chat_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_yellow_chat_area = true
		interact_prompt.visible = true

func _on_yellow_chat_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_yellow_chat_area = false
		interact_prompt.visible = false

func _on_green_chat_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_green_chat_area = true
		interact_prompt.visible = true

func _on_green_chat_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_green_chat_area = false
		interact_prompt.visible = false

func _on_blue_chat_area_body_entered(body: Node2D) -> void:
	if body == self:
		in_blue_chat_area = true
		interact_prompt.visible = true

func _on_blue_chat_area_body_exited(body: Node2D) -> void:
	if body == self:
		in_blue_chat_area = false
		interact_prompt.visible = false
