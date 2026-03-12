class_name Vegetable
extends Node2D

const ANIMATION_PULL := &"pull"
const ANIMATION_RESET := &"RESET"

@export
var animation_player: AnimationPlayer

var is_target : bool = false

func start_pulling() -> void:
    animation_player.play(ANIMATION_PULL)

func stop() -> void:
    animation_player.play(ANIMATION_RESET)
