extends Node


var platformer_score : int = 0
var old_platformer_score : int = 0

var snake_score : int = 0
var old_snake_score : int = 0

var tetris_score : int = 0
var old_tetris_score : int = 0

var dino_run_score : int = 0
var old_dino_run_score : int = 0

var flappy_bird_score : int = 0
var old_flappy_bird_score : int = 0

var total_points_gathered : int
var goal = 600

var game_won : bool = false

var main_theme : bool =  true
var is_in_title : bool = true


func _process(_delta): 
	main_theme = false #delete for sound
	
	total_points_gathered = platformer_score + snake_score + tetris_score + dino_run_score + flappy_bird_score
	if total_points_gathered >= goal:
		main_theme = false
		game_won = true
