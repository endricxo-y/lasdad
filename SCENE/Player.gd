extends KinematicBody2D

export var speed := 200
export var gravity := 1200
export var jump_force := -500

var velocity := Vector2.ZERO

func _ready() -> void:
	$KinematicBody2D.playing = false

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	var input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	velocity.x = input_dir * speed

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	var sprite := $KinematicBody2D
	if input_dir != 0:
		sprite.scale.x = abs(sprite.scale.x) * sign(input_dir)
		sprite.playing = true
		sprite.speed_scale = 2.0
	else:
		sprite.playing = false

	velocity = move_and_slide(velocity, Vector2.UP)
