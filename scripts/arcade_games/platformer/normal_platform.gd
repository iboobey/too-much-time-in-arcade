extends StaticBody2D

@onready var player := get_tree().get_first_node_in_group("Player")
@onready var platforms = get_tree().get_nodes_in_group("Platforms")
var platforms_paths : Array = [
	"res://scenes/arcade_games/platformer/normal_platform.tscn",
	"res://scenes/arcade_games/platformer/breakable_platform.tscn",
	"res://scenes/arcade_games/platformer/frozen_platform.tscn"]

var push_x = 25
var push_y = 5
var warp_right = 100
var warp_left = -90


func _ready() -> void:
	pass

func _on_area_separation_detector_entered(other_area: Area2D) -> void: #Separation Detection
	var other_owner = other_area.get_parent()
	
	if other_owner.scene_file_path in platforms_paths:
		if get_instance_id() < other_owner.get_instance_id():
			
			queue_free() 


func _on_push_detector_area_entered(other_area: Area2D) -> void:
	var other_owner = other_area.get_parent()
	var other_area_x = other_area.global_position.x
	var other_area_y = other_area.global_position.y
	var area_x = global_position.x
	var area_y = global_position.y
	
	if other_owner.scene_file_path in platforms_paths:
		
		if area_x < other_area_x :
			global_position.x = wrap(global_position.x - push_x, warp_left, warp_right)
		
		if area_y < other_area_y :
			global_position.y -= push_y


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if global_position.y > player.global_position.y :
		queue_free()
