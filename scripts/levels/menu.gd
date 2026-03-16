extends CanvasLayer

@export
var start_sound : AudioStreamPlayer

@export
var click_sound : AudioStreamPlayer

@export
var start_button: Button

@export
var exit_button: Button

@export
var next_level: String

var input_enabled : bool

func _input(event):
    if not input_enabled:
        return

    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
        if not click_sound.playing:
            click_sound.play()

func _ready() -> void:
    input_enabled = true
    start_sound.finished.connect(_on_sound_finished)

    start_button.pressed.connect(_on_button_pressed)
    exit_button.pressed.connect(_on_exit_pressed)

    GlobalState.set_key("mini_game_0", false)
    GlobalState.set_key("mini_game_1", false)
    GlobalState.set_key("mini_game_2", false)

func _on_button_pressed() -> void:
    if not input_enabled:
        return

    input_enabled = false
    click_sound.stop()
    start_sound.play()

func _on_sound_finished() -> void:
    SceneManager.change_scene_to(next_level)

func _on_exit_pressed() -> void:
    if not input_enabled:
        return

    input_enabled = false
    get_tree().quit()
