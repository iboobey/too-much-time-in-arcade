extends Node2D


func _ready() -> void:
	%SettingsCanvas.connect("return_pressed",_on_return_pressed)


func _process(_delta: float) -> void:
	if %SettingsCanvas.theme_toggle:
		%TileMapLayerThemes.show()
	else: %TileMapLayerThemes.hide()


func _on_return_pressed() -> void:
	GlobalAudioPlayer.button_click()
	if Global.is_in_title:
		get_tree().change_scene_to_file("res://scenes/title_scene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
