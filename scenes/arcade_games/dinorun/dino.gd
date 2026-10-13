extends CharacterBody2D

@onready var jump_timer: Timer = %JumpTimer

const jump_velocity : float = -450
const gravity : float = 300
const fall_gravity : float = gravity * 2

var is_crouching : bool = false
var is_jumping : bool = false

func _process(delta: float) -> void:
	jump()
	apply_gravity(delta)
	crouch()
	move_and_slide()
	
	if is_on_floor():
		is_jumping = false
		if is_crouching:
			%DinoSprites.play("crouch")
		else: %DinoSprites.play("run")


func jump():
	if jump_timer.time_left == 0.0 and not is_crouching:
		if Input.is_action_pressed("jump") and is_on_floor():
			%DinoSprites.play("jump")
			is_jumping = true
			velocity.y = jump_velocity
			jump_timer.start()
		elif velocity.y < 0.0 and Input.is_action_just_released("jump"):
			is_jumping = false
			velocity.y *= 0.6


func apply_gravity(delta):
	var applied_gravity
	if velocity.y < 0:
		applied_gravity = gravity
	else: applied_gravity = fall_gravity
	
	if not is_on_floor():
		velocity.y += applied_gravity * delta


func crouch():
	
	if Input.is_action_just_pressed("crouch") and not is_jumping:
		is_crouching = true
		
		%RunCollision.disabled = true
		%CrouchCollision.disabled = false
		
		%DinoSprites.play("crouch")
	
	elif Input.is_action_just_released("crouch") and not is_jumping:
		is_crouching = false
		
		%RunCollision.disabled = false
		%CrouchCollision.disabled = true
		
		%DinoSprites.play("run")
	
