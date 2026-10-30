extends Node2D

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var lose_sound_played : bool = false
var scroll
var score : int = 0
var scored_pipe : int = 0
const SCROLL_SPEED : int = 2
var screen_size : Vector2i
const SCREEN_OFFSET := Vector2i(208, 0)
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200
var pipe_color : int = 0


func _ready() -> void:
	screen_size = Vector2i(864,720)
	ground_height = %Ground.get_node("GroundSprite2D").texture.get_height()
	new_game()


func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	pipes.clear()
	generate_pipes()
	%Bird.reset()


func _input(event: InputEvent) -> void:
	if not game_over:
		if event is InputEventKey:
			if event.keycode == KEY_SPACE and event.pressed:
				if not game_running:
					start_game()
				else:
					if %Bird.flying:
						%Bird.flap()
						check_top()
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if not game_running:
					start_game()
				else:
					if %Bird.flying:
						%Bird.flap()
						check_top()


func start_game():
	game_running = true
	%Bird.flying = true
	%Bird.flap()
	%PipeTimer.start()


func _process(_delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		%Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
	if score > Global.flappy_bird_score :
		Global.flappy_bird_score = score
	
	update_label()


func _on_pipe_timer_timeout() -> void:
	generate_pipes()


func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.pipe_color = pipe_color
	pipe.position.x = screen_size.x + SCREEN_OFFSET.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	pipe_color += 1


func check_top():
	if %Bird.position.y < 0:
		%Bird.falling = true
		stop_game()


func stop_game():
	%PipeTimer.stop()
	%Bird.flying = false
	game_running = false
	game_over = true
	
	if not lose_sound_played:
		%ThemeAudioPlayer2D.stop()
		lose_sound_played = true
		%LoseAudioPlayer2D.play()
		await get_tree().create_timer(2.66).timeout
		get_tree().change_scene_to_file("res://scenes/arcade_games/flappybird/flappy_bird_end_screen.tscn")


func bird_hit():
	%Bird.falling = true
	stop_game()


func _on_ground_hit() -> void:
	%Bird.falling = false
	stop_game()


func scored():
	%ScoreAudioPlayer2D.play()
	score += 3
	scored_pipe += 1


func update_label():
	%ScoreLabel.text = "Score: 
" + str(score)
	%HighScoreLabel.text = "High 
Score:
" + str(Global.flappy_bird_score)
	%PipeLabel.text = "Pipes:
" + str(scored_pipe)
