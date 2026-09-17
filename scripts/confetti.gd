extends Node2D

@onready var orange: GPUParticles2D = $Orange
@onready var red: GPUParticles2D = $Red
@onready var blue: GPUParticles2D = $Blue
@onready var green: GPUParticles2D = $Green
@onready var purple: GPUParticles2D = $Purple
@onready var pink: GPUParticles2D = $Pink
@onready var yellow: GPUParticles2D = $Yellow

@onready var pop_timer: Timer = $PopTimer

var pop : bool = true


func _process(_delta: float) -> void:
	if pop:
		orange.emitting = true
		red.emitting = true
		blue.emitting = true
		green.emitting = true
		purple.emitting = true
		pink.emitting = true
		yellow.emitting = true
		pop = false
		pop_timer.start()


func _on_pop_timer_timeout() -> void:
	pop = true
	pop_timer.start()
