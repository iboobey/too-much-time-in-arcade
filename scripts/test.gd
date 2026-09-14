"func apple_spawn():
	var instance = apple.instantiate()
	apple_move(instance)
	add_child(instance)


func apple_move(_instance):
	while apple_regen:
		apple_regen = false
		apple_pos = Vector2(randi_range(0,cells-1),randi_range(0,cells-1))
		for i in snake:
			if (apple_pos * cell_size) + map_offset + Vector2(cell_size / 2.0,cell_size / 2.0) == i.global_position:
				apple_regen = true
		for i in apple_pos_list:
			if apple_pos == i:
				apple_regen = true
	apple_regen = true
	$RedApple.global_position = (apple_pos * cell_size) + map_offset + Vector2(cell_size / 2.0,cell_size / 2.0)
	apple_pos_list.append(apple_pos)"
	#apple_list.append(instance)
	
	#instance.global_position = (apple_pos * cell_size) + map_offset + Vector2(cell_size / 2.0,cell_size / 2.0)
