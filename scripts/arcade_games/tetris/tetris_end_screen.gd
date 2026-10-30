extends Control

@onready var high_score: Label = $HighScoreMargin/HighScore
const CONFETTI := preload("uid://crs2gratwnuim")


func _ready() -> void:
	high_score.text = "High Score:  " + str(Global.tetris_score)
	if Global.old_tetris_score > Global.tetris_score or true:
		var left_confetti = CONFETTI.instantiate()
		var right_confetti = CONFETTI.instantiate()
		left_confetti.global_position = Vector2(0,720)
		add_child(left_confetti)
		right_confetti.global_position = Vector2(1280,720)
		right_confetti.rotation = -45
		add_child(right_confetti)
		Global.old_tetris_score = Global.tetris_score

func _on_try_again_pressed() -> void:
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/arcade_games/tetris/tetris.tscn")


func _on_quit_pressed() -> void:
	Global.main_theme = true
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
