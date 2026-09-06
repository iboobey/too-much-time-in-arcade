extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var interacting_label: Label = $InteractingLabel/InteractingLabel
@onready var interact = get_tree().get_first_node_in_group("InteractionComponent")

var y : float = 0

func  _ready() -> void:
	interactable.interact = action_on_interact
	y = interacting_label.global_position.y


func action_on_interact():
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file("res://scenes/arcade_games/platformer/platformer.tscn")


func _process(_delta):
	if interact.current_interactions and interact.can_interact:
		interacting_label.show()
		
	else:
		interacting_label.hide()
		
