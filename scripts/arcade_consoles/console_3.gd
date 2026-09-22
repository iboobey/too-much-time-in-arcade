extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var interactable: Area2D = $Interactable
@onready var interacting_label: Label = $InteractingLabel/InteractingLabel
@onready var interact = get_tree().get_first_node_in_group("InteractionComponent")

var y : float = 0

func _ready() -> void:
	interactable.interact = action_on_interact
	y = interacting_label.global_position.y


func action_on_interact():
	
	$ConsoleSprite.texture = load("res://graphics/consolesprites/Console3_On.png")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/arcade_games/tetris/tetris.tscn")


func _process(_delta: float) -> void:
	if global_position.distance_to(player.global_position) < 30:
		interacting_label.show()
	else:
		interacting_label.hide()
