extends Node2D

@onready var rich_text_label: RichTextLabel = $MarginText/RichTextLabel


func _ready() -> void:
	rich_text_label.text = "Your objective is to play as many arcade games as you can and to gather at least " + str(Global.goal) + " points. Once you collect enough points, you WIN!"



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_scene.tscn")
