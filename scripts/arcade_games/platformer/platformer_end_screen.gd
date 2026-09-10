extends Control

@onready var points_label: Label = $HighScore/MarginScore2/PointsLabel


func  _ready() -> void:
	points_label.text = "High Score
" + str(Global.platformer_score)


func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/platformer/platformer.tscn")


func _on_end_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
