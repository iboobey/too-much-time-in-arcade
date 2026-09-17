extends Node2D

@onready var you_won_: TextureRect = $"Control/MarginContainer/YouWon!"
@onready var button_parent: Node2D = $Button
@onready var button: Button = $Button/MarginButton/Button

var time_segment : float = 2


func _ready() -> void:
	await get_tree().create_timer(20).timeout
	button_parent.show()


func _process(_delta: float) -> void:
	await get_tree().create_timer(time_segment).timeout
	you_won_.modulate = Color(0.978, 0.972, 0.73, 1.0)
	await get_tree().create_timer(time_segment).timeout
	you_won_.modulate = Color(0.963, 1.0, 0.44, 1.0)
	await get_tree().create_timer(time_segment).timeout
	you_won_.modulate = Color(0.976, 0.973, 0.729, 1.0)
	await get_tree().create_timer(time_segment).timeout
	you_won_.modulate = Color.WHITE

func _on_button_pressed() -> void:
		get_tree().quit()
