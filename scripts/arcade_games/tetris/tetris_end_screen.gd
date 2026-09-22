extends Control

@onready var high_score: Label = $HighScoreMargin/HighScore


func _ready() -> void:
	high_score.text = "High Score:  " + str(Global.tetris_score)


func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/tetris/tetris.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
