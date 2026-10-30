extends Node2D

@onready var score_timer: Timer = %ScoreTimer
@onready var speed_up_timer: Timer = %SpeedUpTimer

var ground_height : int = 616
var sky_height : int = 330

var speed_up_level_factor : int

var stump := preload("res://scenes/arcade_games/dinorun/stump.tscn")
var rock := preload("res://scenes/arcade_games/dinorun/rock.tscn")
var seagull := preload("res://scenes/arcade_games/dinorun/seagull.tscn")
var crow := preload("res://scenes/arcade_games/dinorun/crow.tscn")

var possible_obstacles : Array = [stump, rock]
var possible_birds : Array = [seagull, crow]

var obstacles : Array
var birds : Array

var bird_or_obstacle : Array = ["bird", "bird", "bird", "obstacle", "obstacle", "obstacle"]

var bird_height := [200,390]

var score : int = 1
var start : bool


func _ready() -> void:
	generate_obstacles()


func _process(delta: float) -> void:
	if score > Global.dino_run_score:
		Global.dino_run_score = score
	
	
	if start:
		var ground_x_speed = %Parallax.get_node("PRLX_Ground").autoscroll.x
		move_obstacles(delta, ground_x_speed)
		move_birds(delta, ground_x_speed)
	
	if %Dino.is_dead:
		%Dino.is_dead = false
		%ThemeAudioPlayer2D.stop()
		%DinoDeathAudioPlayer2D.play()
		await get_tree().create_timer(0.1).timeout
		%LoseAudioPlayer2D.play()
		await get_tree().create_timer(2.66).timeout
		get_tree().change_scene_to_file("res://scenes/arcade_games/dinorun/dino_run_end_screen.tscn")
	
	update_label()


func game_start():
	if not %Dino.is_dead:
		start = true
		%Parallax.start = start
		%Dino.start = start
		score_timer.start()
		speed_up_timer.start()
		
		start_obstacle_timer()
		
		%ScoreLabel.show()
		%HighScoreLabel.show()
		%StartButton.disabled = true
		%StartMargin.hide()


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_button_pressed() -> void:
	GlobalAudioPlayer.button_click()
	game_start()


func update_label():
	%ScoreLabel.text = "Score:" + str(score)
	%HighScoreLabel.text = "High Score:" + str(Global.dino_run_score)


func _on_speed_up_timer_timeout() -> void:
	%Parallax.speed_up_level_factor += 1
	%Dino.speed_up_jump_factor += 1
	%Dino.speed_up_gravity_factor += 5
	speed_up_level_factor += 1


func generate_obstacles():
	var type = possible_obstacles.pick_random()
	var instant = type.instantiate()
	
	instant.global_position = Vector2(1800,ground_height)
	add_child(instant)
	
	obstacles.append(instant)


func move_obstacles(delta, ground_x_speed):
	if not obstacles.is_empty():
		for obs in obstacles:
			if is_instance_valid(obs):
				obs.position.x += ground_x_speed * delta * 16


func generate_birds():
	var type = possible_birds.pick_random()
	var instant = type.instantiate()
	var height_variation = randi_range(-30, 35)
	
	instant.global_position = Vector2(1800,sky_height + height_variation)
	add_child(instant)
	
	birds.append(instant)


func move_birds(delta, ground_x_speed):
	if not birds.is_empty():
		for bird in birds:
			if is_instance_valid(bird):
				var speed_multiplier = randf_range(1.2, 1.8)
				
				bird.position.x += ground_x_speed * delta * 16 * speed_multiplier


func start_obstacle_timer():
	var time_speed_up = %Parallax.speed_up_level_factor / 60 * 2.5
	var time = randf_range(2.8 - time_speed_up ,4 - time_speed_up)
	%ObstacleTimer.start(time)


func _on_delete_area_area_entered(area: Area2D) -> void:
	birds.erase(area)
	obstacles.erase(area)
	area.queue_free()


func _on_obstacle_timer_timeout() -> void:
	
	if bird_or_obstacle.is_empty():
		bird_or_obstacle = ["bird", "bird", "bird", "obstacle", "obstacle", "obstacle"]
	
	var selection = bird_or_obstacle.pick_random()
	
	if selection == "bird":
		generate_birds()
	if selection == "obstacle":
		generate_obstacles()
	
	bird_or_obstacle.erase(selection)
	
	start_obstacle_timer()
