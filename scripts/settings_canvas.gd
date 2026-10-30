extends CanvasLayer

signal return_pressed

var theme_toggle : bool = false


func _on_theme_dropdown_button_toggled(toggled_on: bool) -> void:
	theme_toggle = toggled_on
	
	if toggled_on:
		%ThemeVBox.show()
	else:
		%ThemeVBox.hide()


func _on_return_button_pressed() -> void:
	return_pressed.emit()
