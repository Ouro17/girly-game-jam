extends CanvasLayer

@export
var pause_sound : AudioStreamPlayer

@export
var click_sound : AudioStreamPlayer

@export
var is_mini_game : bool

@export
var back_level : String

@export
var menu_level : String

@export
var continue_button : Button

@export
var back_to_somewhere : Button

@export
var exit_button : Button

@export
var back_to_menu : Button

func _input(event):
    if event.is_action_pressed("quit"):
       pause(not get_tree().paused)
       pause_sound.play()
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
        if not click_sound.playing and get_tree().paused:
            click_sound.play()

func pause(value : bool) -> void:
    visible = value
    get_tree().set_deferred("paused", value)

func _ready() -> void:
    continue_button.pressed.connect(_on_continue_pressed)

    if is_mini_game:
        back_to_somewhere.pressed.connect(_on_back_to_map_pressed)
        back_to_menu.pressed.connect(_on_exit_pressed)
        exit_button.visible = false
    else:
        back_to_menu.pressed.connect(_on_back_to_map_pressed)
        exit_button.pressed.connect(_on_exit_pressed)
        back_to_somewhere.visible = false

func _on_continue_pressed() -> void:
    pause(false)

func _on_back_to_map_pressed() -> void:
    if is_mini_game:
        SceneManager.change_scene_to(back_level)
    else:
        click_sound.stop()
        SceneManager.change_scene_to(menu_level)

    pause(false)

func _on_exit_pressed() -> void:
    if is_mini_game:
        SceneManager.change_scene_to(menu_level)
        pause(false)
    else:
        click_sound.stop()
        get_tree().quit()
