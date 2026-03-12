class_name MoleArea
extends Area2D

signal clicked

var mouse_was_pressed: bool

func _input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            mouse_was_pressed = true
        elif not event.pressed and mouse_was_pressed:
            clicked.emit()
            mouse_was_pressed = false