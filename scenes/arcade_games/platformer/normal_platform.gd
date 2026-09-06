extends StaticBody2D

@onready var player := get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	pass

func _on_area_separation_detector_entered(other_area: Area2D) -> void: #Separation Detection
	var other_owner = other_area.get_parent()
	
	if other_owner.scene_file_path == self.scene_file_path:
		if get_instance_id() < other_owner.get_instance_id():
			
			queue_free() 


func _on_push_detector_area_entered(other_area: Area2D) -> void:
	var other_owner = other_area.get_parent()
	var other_area_x = other_area.global_position.x
	var other_area_y = other_area.global_position.y
	var area_x = global_position.x
	var area_y = global_position.y
	
	if other_owner.scene_file_path == self.scene_file_path:
		
		if area_x < other_area_x :
			global_position.x = wrap(global_position.x - 20 ,-100 , 100)
		
		if area_y < other_area_y :
			global_position.y -= 5


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if global_position.y > player.global_position.y :
		queue_free()
