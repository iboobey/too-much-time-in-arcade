extends Node2D

@export var start : bool = false
@export var speed_up_level_factor : int = 0

var start_speed_ground : int = -22
var speed_up : Vector2 = Vector2(1,1) * Vector2(speed_up_level_factor * 0.2 * 2 , 1)

func _process(_delta: float) -> void:
	speed_up = Vector2(1,1) * Vector2(speed_up_level_factor * 0.2 * 2 , 1)
	if speed_up_level_factor >= 200:
		speed_up_level_factor = 0
	
	if start:
		%PRLX_BG.autoscroll = Vector2(start_speed_ground - 4,0) * (speed_up + Vector2(1,0))
		%PRLX_4.autoscroll = Vector2(start_speed_ground - 3,0) * (speed_up + Vector2(1,0))
		%PRLX_3.autoscroll = Vector2(start_speed_ground - 2,0) * (speed_up + Vector2(1,0))
		%PRLX_2.autoscroll = Vector2(start_speed_ground - 1,0) * (speed_up + Vector2(1,0))
		%PRLX_1.autoscroll = Vector2(start_speed_ground,0) * (speed_up + Vector2(1,0))
		%PRLX_Ground.autoscroll = Vector2(start_speed_ground ,0) * (speed_up + Vector2(1,0))
