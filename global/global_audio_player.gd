extends Node2D


func _process(_delta: float) -> void:
	if Global.main_theme and not %MainThemeAudioPlayer.playing:
		%MainThemeAudioPlayer.play()
	if not Global.main_theme and %MainThemeAudioPlayer.playing:
		%MainThemeAudioPlayer.stop() 


func button_click():
	%ButtonAudioPlayer2D.play()
