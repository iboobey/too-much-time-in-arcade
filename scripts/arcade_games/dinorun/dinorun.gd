extends Node2D

@onready var score_timer: Timer = %ScoreTimer
@onready var speed_up_timer: Timer = %SpeedUpTimer


var score : int = 1

func _process(_delta: float) -> void:
	if score > Global.dino_run_score:
		Global.dino_run_score = score
	update_label()


func game_start():
	%Parallax.start = true
	%Dino.start = true
	score_timer.start()
	speed_up_timer.start()
	
	%ScoreLabel.show()
	%HighScoreLabel.show()
	%StartButton.disabled = true
	%StartButton.hide()


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_button_pressed() -> void:
	game_start()


func update_label():
	%ScoreLabel.text = "Score:" + str(score)
	%HighScoreLabel.text = "High Score:" + str(Global.dino_run_score)


func _on_speed_up_timer_timeout() -> void:
	%Parallax.speed_up_level_factor += 1
	%Dino.speed_up_jump_factor -= 30
	%Dino.speed_up_gravity_factor += 60
