extends CanvasLayer

@export
var texture : TextureRect

@export
var animation_player : AnimationPlayer

@export
var animation_tree : AnimationTree

@export
var pause_menu : PauseMenu

func _ready() -> void:
    texture.mouse_entered.connect(_on_mouse_entered)
    texture.mouse_exited.connect(_on_mouse_exited)
    texture.gui_input.connect(_on_gui_input)

func _on_mouse_entered() -> void:
    animation_player.play(&"play")
    GlobalState.set_key(&"Area", true)
    animation_tree.set(&"parameters/conditions/play", true)
    animation_tree.set(&"parameters/conditions/back", false)

func _on_mouse_exited() -> void:
    animation_player.play(&"back")
    GlobalState.set_key(&"Area", false)
    animation_tree.set(&"parameters/conditions/play", false)
    animation_tree.set(&"parameters/conditions/back",true)

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        pause_menu.pause(not get_tree().paused)
