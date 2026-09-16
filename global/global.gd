extends Node


var platformer_score : int = 0
var snake_score : int = 0


var total_points_gathered = platformer_score + snake_score 

var game_won : bool = false

func _process(_delta):
	total_points_gathered = platformer_score + snake_score
	if total_points_gathered >= 400:
		game_won = true
