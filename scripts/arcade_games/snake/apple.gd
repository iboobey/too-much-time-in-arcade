extends Node2D

@onready var red_apple = preload("res://graphics/gamesprites/snakesprites/Apples/RedApple.png")
@onready var green_apple = preload("res://graphics/gamesprites/snakesprites/Apples/GreenApple.png")
@onready var yellow_apple = preload("res://graphics/gamesprites/snakesprites/Apples/YellowApple.png")

@onready var apple_colors : Array = [red_apple, green_apple, yellow_apple]

@onready var apple_sprite: Sprite2D = $AppleSprite

func _ready() -> void:
	apple_sprite.texture = apple_colors.pick_random()
