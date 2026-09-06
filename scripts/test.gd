extends Node

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var jump_velocity = player.jump_velocity
@onready var gravity = player.gravity
@onready var fall_gravity = player.fall_gravity
@onready var speed = player.speed
var safety_factor = .75
var last_y := 0.0


var normal_platform : PackedScene = preload("res://scenes/arcade_games/platformer/normal_platform.tscn")


func _ready() -> void:
	var player_pos_y = player.global_position.y
	spawn_set(player_pos_y,Color.BLUE)
	spawn_set(player_pos_y+135,Color.RED)
	spawn_set(player_pos_y+270,Color.GREEN)

func _process(_delta):
	pass
	


func sort_by_y(platform1,platform2):

	var platform1_y = platform1.global_position.y
	var platform2_y = platform2.global_position.y
	return platform1_y < platform2_y


func max_jump_height():
	return (jump_velocity ** 2) / (2 * gravity)

func max_jump_distance():
	var velocity_abs = abs(jump_velocity)
	var time_jump = velocity_abs / gravity
	var time_fall = velocity_abs / sqrt(gravity * fall_gravity)
	var time_air = time_jump + time_fall
	return speed * time_air


func spawn_set(player_y,coloor):

	var random_y = randf_range(-(abs(player_y)),-(abs(player_y + max_jump_height())))
	var random_x = randf_range(-50,50)
	var min_y = 60
	var min_x = 45
	var platform_amount = randi_range(2,3)
	var random_x_list := []
	var random_y_list := []
	var platforms := []
	
	
	
	
	
	
	for i in platform_amount   : #random lists
		random_x_list.append(randf_range(-50,50))
		random_y_list.append(randf_range(-50,50))

	random_y_list.sort()
	
	for i in range(1,random_y_list.size()) : #y adjust
		var low = random_y_list[i-1]
		var high = random_y_list[i]
		var distance_between_y = high - low
		
		if distance_between_y < min_y :
			random_y_list[i] += min_y
	
	for i in range(1,random_x_list.size()) : # x adjust
		var right = random_x_list[i-1]
		var left = random_x_list[i]
		var distance_between_x =  right - left
		var operation = randf()
	
		if operation < .5 :
			min_x = - min_x
		
		
		if distance_between_x < min_x :
			random_x_list[i] += min_x
	
	for i in platform_amount : #instantiate
		if i != 1:
			var instance = normal_platform.instantiate()
			instance.modulate = coloor
			instance.global_position.y += (random_y + random_y_list[i-1]) * safety_factor
			instance.global_position.x += random_x + random_x_list[i-1]
			instance.global_position.y = -abs(instance.global_position.y)
			instance.global_position.x = -abs(instance.global_position.x)
			add_child(instance)
			platforms.append(instance)
		else:
			var instance = normal_platform.instantiate()
			instance.modulate = coloor
			instance.global_position.y += random_y * safety_factor
			instance.global_position.x += random_x
			instance.global_position.y = -abs(instance.global_position.y)
			instance.global_position.x = -abs(instance.global_position.x)
			add_child(instance)
			platforms.append(instance)


func spawn_platform(player_y,coloor):
	spawn_set(player_y,coloor)
	
