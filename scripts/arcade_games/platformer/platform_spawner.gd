extends Node2D

@onready var player := $"../Player"
@onready var jump_velocity = player.jump_velocity
@onready var gravity = player.gravity 
@onready var fall_gravity = player.fall_gravity
@onready var speed = player.speed
var safety_factor = .65
var last_trigger_y := 0.0
const trigger_distance := 300.0
const trigger_offset := 200.0
var trigger_amount : int = 0

var normal_platform : PackedScene = preload("res://scenes/arcade_games/platformer/normal_platform.tscn")
var breakable_platform : PackedScene = preload("res://scenes/arcade_games/platformer/breakable_platform.tscn")
var frozen_platform : PackedScene = preload("res://scenes/arcade_games/platformer/frozen_platform.tscn")
var platforms : Array = [normal_platform, frozen_platform, breakable_platform]

var weight_start : PackedFloat32Array = [70.0, 18.0, 12.0]
var weight_2 : PackedFloat32Array = [60.0, 23.0, 17.0]
var weight_3 : PackedFloat32Array = [50.0, 28.0, 22.0]
var weight_4 : PackedFloat32Array = [40.0, 33.0, 27.0]
var weight_5 : PackedFloat32Array = [30.0, 38.0, 32.0]
var weights : Array = [weight_start, weight_2, weight_3, weight_4, weight_5]

func _ready() -> void:
	spawn_set(trigger_amount)
	spawn_set(trigger_amount)
	last_trigger_y = player.global_position.y 

func _process(_delta):
	var up_distance : float = last_trigger_y - player.global_position.y
	if up_distance >= trigger_distance:
		trigger_amount += 1
		last_trigger_y -= trigger_distance
		spawn_set(trigger_amount)
		spawn_set(trigger_amount)


func max_jump_height():
	return (jump_velocity * jump_velocity) / (2 * gravity)

func total_jump_time():
	var time_jump = abs(jump_velocity) / gravity
	var time_fall = abs(jump_velocity) / sqrt(gravity * fall_gravity)
	var time_air = time_jump + time_fall
	return time_air

func max_jump_distance():
	var max_speed = total_jump_time() * speed  
	return max_speed



func spawn_set(trigger_amount_,):
	var platform_amount = 20 
	
	
	var last_y = 0 + trigger_amount_ * (trigger_distance + trigger_offset)
	var last_x = randf_range(-50,50)
	
	for i in platform_amount:
		
		var rng = RandomNumberGenerator.new()
		var weight_index = ceil(trigger_amount_ / 3) if not(trigger_amount_ / 3 >= 5) else 4 
		var index = rng.rand_weighted(weights[weight_index])
		var platform = platforms[index]
		var instance = platform.instantiate()
		
		var random_x = wrap(last_x + randf_range(-40,40) * safety_factor,-80,80)
		var random_y = -(last_y + randf_range(20,max_jump_height() * safety_factor))
		
		instance.global_position.x = random_x
		instance.global_position.y = random_y
		last_y = random_y * -1
		last_x = random_x * -1
		
		
		add_child(instance)
		




func _on_start_area_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	if area_parent.name == "NormalPlatform:<StaticBody2D#27111982532>" : 
		area_parent.queue_free()
