extends Control

@onready var points_label: Label = $HighScore/MarginScore2/PointsLabel
const CONFETTI := preload("res://scenes/confetti.tscn")

func  _ready() -> void:
	points_label.text = "High Score
" + str(Global.platformer_score)
	
	if Global.platformer_score > Global.old_platformer_score:
		var left_confetti = CONFETTI.instantiate()
		var right_confetti = CONFETTI.instantiate()
		left_confetti.global_position = Vector2(0,720)
		add_child(left_confetti)
		right_confetti.global_position = Vector2(1280,720)
		right_confetti.rotation = -45
		add_child(right_confetti)
		Global.old_platformer_score = Global.platformer_score


func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/platformer/platformer.tscn")


func _on_end_game_pressed() -> void:
	Global.main_theme = true
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
