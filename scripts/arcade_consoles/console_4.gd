extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var interactable: Area2D = $Interactable
@onready var interacting_label: Node2D = $InteractingLabel
@onready var interact = get_tree().get_first_node_in_group("InteractionComponent")

var y : float = 0

func _ready() -> void:
	interactable.interact = action_on_interact
	y = interacting_label.global_position.y


func _process(_delta: float) -> void:
	if global_position.distance_to(player.global_position) < 30:
		interacting_label.show()
	else:
		interacting_label.hide()


func action_on_interact():
	Global.main_theme = false
	%AudioStreamPlayer2D.play()
	$ConsoleSprite.texture = load("res://graphics/consolesprites/Console4_On.png")
	await get_tree().create_timer(0.67).timeout
	get_tree().change_scene_to_file("res://scenes/arcade_games/tetris/tetris.tscn")
