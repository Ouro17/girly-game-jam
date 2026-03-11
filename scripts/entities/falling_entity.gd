class_name FallingEntity
extends CharacterBody2D

@export
var is_bad : bool

func _physics_process(delta: float) -> void:
    velocity += get_gravity() * delta
    move_and_slide()
