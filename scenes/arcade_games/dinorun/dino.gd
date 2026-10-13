extends CharacterBody2D

@onready var jump_timer: Timer = %JumpTimer

const jump_velocity : float = -450
const gravity : float = 300
const fall_gravity : float = gravity * 1.7

func _process(delta: float) -> void:
	jump()
	apply_gravity(delta)
	move_and_slide()


func jump():
	if jump_timer.time_left == 0.0:
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			jump_timer.start()
		elif velocity.y < 0.0 and Input.is_action_just_released("jump"):
			velocity.y *= 0.6


func apply_gravity(delta):
	var applied_gravity
	if velocity.y < 0:
		applied_gravity = gravity
	else: applied_gravity = fall_gravity
	
	if not is_on_floor():
		velocity.y += applied_gravity * delta
