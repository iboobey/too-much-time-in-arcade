class_name Snake_Head extends SnakePart

signal apple_eaten



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("SnakeApple"):
		
		apple_eaten.emit()
		area.call_deferred("queue_free")
		print("hamham")
	else:
		print("hamhama")
		pass
