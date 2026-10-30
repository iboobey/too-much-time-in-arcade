extends Node2D



func _on_quit_pressed() -> void:
	GlobalAudioPlayer.button_click()
	get_tree().quit()


func _on_settings_pressed() -> void:
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/settings_scene.tscn")


func _on_play_pressed() -> void:
	Global.is_in_title = false
	GlobalAudioPlayer.button_click()
	get_tree().change_scene_to_file("res://scenes/transition_scene.tscn")
