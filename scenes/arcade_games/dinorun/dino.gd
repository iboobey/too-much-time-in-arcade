extends CharacterBody2D

@export var speed_up_jump_factor : int = -450
@export var speed_up_gravity_factor : int = 300


@export var start : bool = false
var start_anim : bool = false
@onready var jump_timer: Timer = %JumpTimer

var jump_velocity : float = -450
var gravity : float = 300
var fall_gravity : float = gravity * 2

var is_crouching : bool = false
var is_jumping : bool = false

func _process(delta: float) -> void:
	
	print(gravity)
	
	gravity = speed_up_gravity_factor
	jump_velocity = speed_up_jump_factor
	
	if start:
		if not start_anim:
			%DinoSprites.play("run")
			start_anim = true
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
	
