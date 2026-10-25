extends AudioStreamPlayer2D


func _process(_delta: float) -> void:
	if Global.main_theme and not playing:
		play()
	if not Global.main_theme and playing:
		stop() 
