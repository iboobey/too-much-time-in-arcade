extends Node


var platformer_score : int = 0
var snake_score : int = 0
var tetris_score : int = 0

var total_points_gathered : int
var goal = 400

var game_won : bool = false

func _process(_delta):
	total_points_gathered = platformer_score + snake_score + tetris_score
	if total_points_gathered >= goal:
		game_won = true
