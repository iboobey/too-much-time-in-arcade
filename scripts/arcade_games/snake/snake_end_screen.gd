extends Control

@onready var high_score_label: Label = $HighScore/HighScoreLabel

func _ready() -> void:
	high_score_label.text = "High Score:

" + str(Global.snake_score)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/snake/snake.tscn")


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
