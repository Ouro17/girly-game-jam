class_name MiniGame
extends Node2D

@export
var next_level: String

@export
var timer : Timer

@export
var state : State

func _ready() -> void:
    timer.timeout.connect(_on_time_out)

func _on_time_out()-> void:
    _level_complete(true)

func _level_complete(result : bool)-> void:
    _save_state(result)
    EventBus.observers.emit(state.id)

    SceneManager.change_scene_to(next_level)

func _save_state(value: bool) -> void:
    if state != null:
        return state.save_state(value)