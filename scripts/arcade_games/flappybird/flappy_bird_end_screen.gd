extends Control

const CONFETTI := preload("res://scenes/confetti.tscn")

func _ready() -> void:
	%HighScoreLabel.text = "High Score:

" + str(Global.flappy_bird_score)
	
	if Global.flappy_bird_score > Global.old_flappy_bird_score:
		var left_confetti = CONFETTI.instantiate()
		var right_confetti = CONFETTI.instantiate()
		left_confetti.global_position = Vector2(0,720)
		add_child(left_confetti)
		right_confetti.global_position = Vector2(1280,720)
		right_confetti.rotation = -45
		add_child(right_confetti)
		Global.old_flappy_bird_score = Global.flappy_bird_score




func _on_try_again_pressed() -> void:
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/arcade_games/flappybird/flappy_bird.tscn")

func _on_exit_pressed() -> void:
	Global.main_theme = true
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
