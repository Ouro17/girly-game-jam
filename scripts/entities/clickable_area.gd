class_name ClickableArea
extends Area2D

signal clicked

var mouse_was_pressed: bool

func _ready():
    GlobalState.set_key(&"Area", false)
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
    GlobalState.set_key(&"Area", true)

func _on_mouse_exited():
    GlobalState.set_key(&"Area", false)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            mouse_was_pressed = true
        elif not event.pressed and mouse_was_pressed:
            clicked.emit()
            mouse_was_pressed = false
