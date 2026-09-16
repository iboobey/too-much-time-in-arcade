extends Node2D


@onready var score_hundreds_digit: AnimatedSprite2D = $Score/ScoreLabel/ScoreHundredsDigit
@onready var score_tens_digit: AnimatedSprite2D = $Score/ScoreLabel/ScoreTensDigit
@onready var score_unit_digit: AnimatedSprite2D = $Score/ScoreLabel/ScoreUnitDigit

@onready var lights: Node2D = $Lights
@onready var score_light: PointLight2D = $Score/ScoreLight

var tree = Engine.get_main_loop()

func _process(_delta):
	scoreboard()
	if Global.game_won == true:
		game_won()
		Global.game_won = false


func scoreboard():
	
	var hundreds_digit  = int(Global.total_points_gathered / 100.0) % 10
	var tens_digit  = int(Global.total_points_gathered / 10.0) % 10
	var units_digit = Global.total_points_gathered % 10
	
	
	score_hundreds_digit.frame = hundreds_digit
	score_tens_digit.frame = tens_digit
	score_unit_digit.frame = units_digit


func game_won():
	await tree.create_timer(0.4).timeout
	lights.hide()
	await tree.create_timer(0.6).timeout
	score_light.show()
	await tree.create_timer(1.2).timeout
	tree.change_scene_to_file("res://scenes/win_screen.tscn")
