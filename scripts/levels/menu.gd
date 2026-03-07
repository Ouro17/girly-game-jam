extends Control

@export
var start_button: Button

@export
var exit_button: Button

@export
var next_level: String

func _ready() -> void:
    if start_button:
        start_button.pressed.connect(_on_button_pressed)

    if exit_button:
        exit_button.pressed.connect(_on_exit_pressed)

func _on_button_pressed() -> void:
    SceneManager.change_scene_to(next_level)

func _on_exit_pressed() -> void:
    get_tree().quit()
