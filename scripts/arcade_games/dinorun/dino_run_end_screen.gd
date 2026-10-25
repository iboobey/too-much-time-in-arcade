extends Node2D


func _ready() -> void:
	%HighScoreLabel.text = "High Score:

" + str(Global.dino_run_score)



func _on_exit_button_pressed() -> void:
	Global.main_theme = true
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/dinorun/dinorun.tscn")
