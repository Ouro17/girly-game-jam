extends Node2D

@export
var next_level: String

@export
var timer : Timer

func _ready() -> void:
    timer.timeout.connect(_on_time_out)

func _input(event):
    if event is InputEventKey and event.pressed:
        _next_level()
        get_viewport().set_input_as_handled()


func _on_time_out()-> void:
    SceneManager.change_scene_to(next_level)

func _next_level()-> void:
    timer.stop()
    SceneManager.change_scene_to(next_level)