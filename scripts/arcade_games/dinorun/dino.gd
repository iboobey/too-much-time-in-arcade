extends CharacterBody2D

@export var speed_up_jump_factor : int = 0
@export var speed_up_gravity_factor : int = 0

@export var start : bool = false
var start_anim : bool = false
@onready var jump_timer: Timer = %JumpTimer

var jump_velocity : float = -750
var gravity : float = 600
var fall_gravity : float = gravity * 2

var is_crouching : bool = false
var is_jumping : bool = false

var is_dead : bool = false


var last_jump : Vector2 = Vector2(80, -160)
var last_fall : Vector2 = Vector2(20, 30)

func _process(delta: float) -> void:
	
	fall_gravity = gravity * 2 * (1 + speed_up_gravity_factor * 0.015)
	
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
		%RunHurtCollision.disabled = true
		%CrouchCollision.disabled = false
		%CrouchHurtCollision.disabled = false
		
		%DinoSprites.play("crouch")
	
	elif Input.is_action_just_released("crouch") and not is_jumping:
		is_crouching = false
		
		%RunCollision.disabled = false
		%RunHurtCollision.disabled = false
		%CrouchCollision.disabled = true
		%CrouchHurtCollision.disabled = true
		
		%DinoSprites.play("run")


func _on_hurt_collision_area_entered(_area: Area2D) -> void:
	is_dead = true
	dino_dying()


func dino_dying():
	%RunCollision.set_deferred("disabled", true)
	%CrouchCollision.set_deferred("disabled", true)
	%RunHurtCollision.set_deferred("disabled", true)
	%CrouchHurtCollision.set_deferred("disabled", true)
	
	z_index = 9
	
	var fall_tween = get_parent().create_tween()
	
	last_fall = last_fall*2 + global_position
	
	fall_tween.tween_property(self, "global_position", last_fall, 0.15)
	
