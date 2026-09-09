extends CharacterBody2D

var speed := 3200
const sprint_scale := 1.4
const gravity := 210
const fall_gravity := 220
var jump_velocity := -150

var can_jump : bool = false
var platformer : bool = false
var is_on_ice : bool = false

@onready var platformer_camera_limit_x : int = 150

@export_range(0.01, 1.0, 0.01) var grip: float = 0.25
@export_range(0.01, 1.0, 0.01) var ice_grip: float = 0.03


@onready var platformer_scene : PackedScene = preload("res://scenes/arcade_games/platformer/platformer.tscn")



@onready var camera: Camera2D = $Camera2D

@onready var shoe_anim := $CompositeSprites/ShoeRed
@onready var torso_anim := $CompositeSprites/TorsoGreen
@onready var short_anim := $CompositeSprites/ShortBlue
@onready var head_anim := $CompositeSprites/Head
@onready var hair_anim := $CompositeSprites/HairCurly
@onready var cap_anim := $CompositeSprites/CapRed



func _ready() -> void:
	
	if platformer_scene.emit_signal("ready"):
		print("yes")
		$Camera2D.set_limit(SIDE_LEFT,-platformer_camera_limit_x)
		$Camera2D.set_limit(SIDE_RIGHT,platformer_camera_limit_x)
		
func move(delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed * delta
	if Input.is_action_pressed("run"):
		velocity = velocity * sprint_scale


func platformer_move(delta):
	var direction = Input.get_axis("left","right")
	var current_grip = ice_grip if is_on_ice else grip
	var target_speed = direction * speed * delta
	velocity.x = lerp(velocity.x, target_speed, current_grip)
	
	jump()
	apply_gravity(delta)


func _set_on_ice(value:bool) -> void:
	is_on_ice = value


func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_jump:
		velocity.y = jump_velocity
	elif velocity.y < 0.0 and Input.is_action_just_released("jump"):
		velocity.y *= 0.6


func apply_gravity(delta):
	var applied_gravity 
	if velocity.y < 0:
		applied_gravity = gravity
	else: applied_gravity = fall_gravity
	
	if not is_on_floor():
		velocity.y += applied_gravity * delta


func walk_animation():
	var direction_h := Input.get_axis("left","right")
	var direction_v := Input.get_axis("down","up")
	var walk_direction : String

	if Input.is_action_pressed("run"):
		cap_anim.speed_scale = sprint_scale
		hair_anim.speed_scale = sprint_scale
		head_anim.speed_scale = sprint_scale
		torso_anim.speed_scale = sprint_scale
		shoe_anim.speed_scale = sprint_scale
		short_anim.speed_scale = sprint_scale
		
	if direction_h != 0 or direction_v != 0:
		if direction_h < 0:
			walk_direction = "walkleft"
		elif direction_h > 0:
			walk_direction = "walkright"
		else:
			if not platformer:
				if direction_v < 0 :
					walk_direction = "walkdown"
				elif direction_v > 0:
					walk_direction = "walkup"
	else:
		cap_anim.frame = 0
		hair_anim.frame = 0
		head_anim.frame = 0
		torso_anim.frame = 0
		shoe_anim.frame = 0
		short_anim.frame = 0
	
	
	cap_anim.play(walk_direction)
	hair_anim.play(walk_direction)
	head_anim.play(walk_direction)
	torso_anim.play(walk_direction)
	shoe_anim.play(walk_direction)
	short_anim.play(walk_direction)


func _physics_process(delta):
	walk_animation()
	if platformer:
		$PlatformerCollision.disabled = false
		platformer_move(delta)
	else: move(delta)
	move_and_slide()
	
