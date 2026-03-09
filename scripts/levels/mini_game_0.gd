class_name MiniGame0
extends Node2D

@export
var mini_game_intro : MiniGameIntro

@export
var movement_area: Area2D

@export
var chickens : Array[Chicken]

@export
var next_level: String

@export
var state : State

func _ready() -> void:
    mini_game_intro.intro_finished.connect(_on_intro_finished)

func _on_intro_finished() -> void:
    mini_game_intro.visible = false
    for chicken in chickens:
        chicken.set_enable(true)

func _on_time_out()-> void:
    _level_complete(true)

func _level_complete(result : bool)-> void:
    _save_state(result)
    EventBus.observers.emit(state.id)

    SceneManager.change_scene_to(next_level)

func _save_state(value: bool) -> void:
    if state != null:
        return state.save_state(value)
