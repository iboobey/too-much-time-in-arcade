extends Node2D

@onready var player = $Player

@onready var death_area: Area2D = $DeathArea
@onready var points_label: Label = $GUI/MarginContainer/VBoxContainer/Points/MarginContainer/Points
@onready var max_points_label: Label = $GUI/MarginContainer/VBoxContainer/MaxPoints/MarginContainer/MaxPoints
@onready var player_y_level_label: Label = $GUI/MarginContainer/VBoxContainer/PlayerYLevel/MarginContainer/PlayerYLevel

@onready var camera : Camera2D = get_viewport().get_camera_2d()
@onready var camera_limit_x : int = 150


var death_area_offset := 300.0
var player_high_y := -death_area_offset
var score : int = 0
var scored_high_y = 0


func _ready() -> void:
	player.can_jump = true
	player.platformer = true
	
	camera.set_limit(SIDE_RIGHT, camera_limit_x)
	camera.set_limit(SIDE_LEFT, -camera_limit_x)
	

	


func _process(_delta):
	
	death_area_movement()
	
	var scored_y = (-(floori(player.global_position.y) + 17) / 5.0) - 0.2
	
	if scored_high_y < scored_y:
		scored_high_y = scored_y
		score = scored_high_y / 10.0
		points_label.text = "Points:
" + str(score)
	
	if score > Global.platformer_score:
		Global.platformer_score = score
	
	
	
	player_y_level_label.text = "Player Y
Level:
" + str(scored_y)
	
	max_points_label.text = "Max
Points:
" + str(Global.platformer_score)
	


func death_area_movement():
	if player.global_position.y < player_high_y:
		player_high_y = player.global_position.y
		death_area.global_position.y = player_high_y 
	pass
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$StartPlatform/StartPlatformSprite.visible = false
	$StartPlatform/StartPlatformCollision.disabled = true


func _on_death_area_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().call_deferred("change_scene_to_file","res://scenes/arcade_games/platformer/platformer_end_screen.tscn")
