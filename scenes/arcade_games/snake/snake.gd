extends Node2D


@onready var snake_body_scene = preload("res://scenes/arcade_games/snake/snake_body.tscn")
@onready var move_timer: Timer = $MoveTimer
@onready var time_keeper_timer: Timer = $TimeKeeperTimer

@onready var apple := preload("res://scenes/arcade_games/snake/apple.tscn")

@onready var score_label: Label = $UI/MarginContainer/VBoxContainer/Score/ScoreLabel
@onready var max_score_label: Label = $UI/MarginContainer/VBoxContainer/MaxScore/MaxScoreLabel
@onready var time_label: Label = $UI/MarginContainer/VBoxContainer/Time/TimeLabel


var score : int = 0
var time_passed : int = 0
var game_started : bool = false

var cells : int = 20
var cell_size : int = 30


var old_data : Array
var snake_data : Array
var snake : Array

var starting_position = Vector2(9,9)

var up = Vector2(0,-1)
var down = Vector2(0,1)
var left = Vector2(-1,0)
var right = Vector2(1,0)
var direction : Vector2
var can_move: bool

var apple_pos : Vector2
var apple_pos_list : Array = []
var apple_list : Array = []

var map_x_offset := 340
var map_y_offset := 60
var map_offset := Vector2(map_x_offset,map_y_offset)

var border_up = map_y_offset - cell_size
var border_down = map_y_offset + (cells * cell_size)
var border_left = map_x_offset - cell_size
var border_right = map_x_offset + (cells * cell_size)


func  _ready() -> void:
	new_game()


func _process(_delta: float) -> void:
	move()
	
	if score > Global.snake_score :
		Global.snake_score = score
	print(snake_data[1]+Vector2(9,9))
	update_label()
	instantiate_apple()


func new_game():
	direction = up
	can_move = true
	generate_snake()
	for i in 3:
		instantiate_apple()


func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	
	for i in range(3):
		add_segment(starting_position + Vector2(0,i))


func add_segment(pos):
	snake_data.append(position)
	var snake_body = snake_body_scene.instantiate()
	snake_body.position = pos * cell_size + map_offset
	add_child(snake_body)
	snake.append(snake_body)


func move():
	if can_move:
		if Input.is_action_just_pressed("down") and direction != up:
			direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("up") and direction != down:
			direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("right") and direction != left:
			direction = right
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("left") and direction != right:
			direction = left
			can_move = false
			if not game_started:
				start_game()


func start_game():
	game_started = true
	time_keeper_timer.start()
	move_timer.start()


func _on_move_timer_timeout() -> void:
	can_move = true
	old_data = [] + snake_data
	snake_data[0] += direction
	for i in range(len(snake_data)):
		if i > 0 :
			snake_data[i] = old_data[i - 1]
		snake[i].position = ((snake_data[i] + starting_position) * cell_size) + map_offset  
	check_border()
	check_cannibalism()
	check_apple_eaten()


func check_border():
	if not(snake[0].global_position.x < border_right) or not(snake[0].global_position.x > border_left) or not(snake[0].global_position.y < border_down) or not(snake[0].global_position.y > border_up) : 
		end_game() 


func check_cannibalism():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()


func instantiate_apple():
	var instance = apple.instantiate() 
	var apple_global_pos
	
	apple_pos = Vector2(randi_range(0,cells-1),randi_range(0,cells-1))
	apple_global_pos = (apple_pos * cell_size) + map_offset
	
	for i in len(snake_data):
		if apple_global_pos == (snake_data[i] + Vector2(9,9)):
			apple_pos = Vector2(randi_range(0,cells),randi_range(0,cells))
		else:
			break
	print(apple_pos)
	
	instance.global_position = (apple_pos * cell_size) + map_offset + Vector2(cell_size / 2.0,cell_size / 2.0)
	
	apple_list.append(instance)
	apple_pos_list.append(instance.global_position - Vector2(cell_size / 2.0,cell_size / 2.0))
	
	add_child(instance)


func check_apple_eaten():
	for i in len(apple_pos_list):
		if snake[0].global_position == apple_pos_list[i]:
			score += 1
			apple_list[i].queue_free()
			apple_list.remove_at(i)
			apple_pos_list.remove_at(i)
			
			add_segment(old_data[-1])
			instantiate_apple()


func  end_game():
	Global.snake_score = score
	get_tree().change_scene_to_file("res://scenes/arcade_games/snake/snake_end_screen.tscn")


func _on_time_keeper_timer_timeout() -> void:
	time_passed += 1


func update_label(): 
	
	score_label.text = "SCORE:
	" + str(score)
	
	max_score_label.text = "MAX SCORE:

	" + str(Global.snake_score)
	
	time_label.text = "Time Spent:

" + str(time_passed)
