extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var death_area := $DeathArea
var player_high_y := 0.0
var death_area_offset := 300.0


func _ready() -> void:
	player.can_jump = true
	player.platformer = true


func _process(_delta):
	death_area_movement()


func death_area_movement():
	if is_instance_valid(player):
		if player.global_position.y < player_high_y:
			player_high_y = player.global_position.y
			death_area.global_position.y = player_high_y + death_area_offset


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$StartPlatform/StartPlatformSprite.visible = false
	$StartPlatform/StartPlatformCollision.disabled = true


func _on_death_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/arcade_games/platformer/platformer_end_screen.tscn")
	print("aAaAa")

func end_scene():
	get_tree().change_scene_to_file("res://scenes/arcade_games/platformer/platformer_end_screen.tscn")
