extends KinematicBody2D

export var speed := 200
export var hop_height := 4.0
export var hop_speed := 10.0
export var camera_zoom := 0.5 setget set_camera_zoom

var velocity := Vector2.ZERO
var hop_time := 0.0
var original_sprite_pos := Vector2.ZERO

func _ready() -> void:
	original_sprite_pos = $AnimatedSprite.position
	$Camera2D.zoom = Vector2(camera_zoom, camera_zoom)

func set_camera_zoom(value: float) -> void:
	camera_zoom = value
	if is_inside_tree():
		$Camera2D.zoom = Vector2(camera_zoom, camera_zoom)

func _physics_process(delta: float) -> void:
	var input_dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_dir.length() > 0:
		velocity = input_dir.normalized() * speed
		update_animation(input_dir)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite.playing = false

	velocity = move_and_slide(velocity)

func _process(delta: float) -> void:
	if velocity.length() > 0:
		hop_time += delta * hop_speed
		$AnimatedSprite.position.y = original_sprite_pos.y + abs(sin(hop_time)) * -hop_height
	else:
		hop_time = 0.0
		$AnimatedSprite.position.y = original_sprite_pos.y

func update_animation(dir: Vector2) -> void:
	var angle := rad2deg(dir.angle())
	var anim := "down"

	if angle >= -22.5 and angle < 22.5:
		anim = "right"
	elif angle >= 22.5 and angle < 67.5:
		anim = "right"
	elif angle >= 67.5 and angle < 112.5:
		anim = "down"
	elif angle >= 112.5 and angle < 157.5:
		anim = "down_left"
	elif angle >= 157.5 or angle < -157.5:
		anim = "left"
	elif angle >= -157.5 and angle < -112.5:
		anim = "up_left"
	elif angle >= -112.5 and angle < -67.5:
		anim = "up"
	elif angle >= -67.5 and angle < -22.5:
		anim = "up_right"

	if $AnimatedSprite.animation != anim:
		$AnimatedSprite.animation = anim
	$AnimatedSprite.playing = true
