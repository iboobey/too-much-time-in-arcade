extends Area2D

signal hit
signal scored

@onready var green_pipe := preload("res://graphics/gamesprites/flappybirdsprites/Green_Pipe.png")
@onready var blue_pipe := preload("res://graphics/gamesprites/flappybirdsprites/Blue_Pipe.png")
@onready var red_pipe := preload("res://graphics/gamesprites/flappybirdsprites/Red_Pipe.png")

var pipe_color : int = 0

func _on_body_entered(_body: Node2D) -> void:
	hit.emit()


func _on_score_area_body_entered(_body: Node2D) -> void:
	scored.emit()


func _ready() -> void:
	var sprite
	if pipe_color < 30:
		sprite = green_pipe
	elif pipe_color >= 30 and pipe_color < 50:
		sprite = blue_pipe
	elif pipe_color >= 50:
		sprite = red_pipe
	
	%LowerSprite.texture = sprite
	%UpperSprite.texture = sprite
	
	var random_y_offset : float = randf_range(-20,10)
	
	$UpperCollision.position.y += random_y_offset
