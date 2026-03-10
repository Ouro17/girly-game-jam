class_name NumberHolder
extends Panel

@export
var label : Label

@export
var current_value : int

@export
var has_max_value : bool

@export
var max_value : int

var is_max_value_reached : bool

func set_value(new_value : int) -> void:
    if has_max_value:
        current_value = clamp(new_value, 0, max_value)
        is_max_value_reached = current_value == max_value
    else:
        current_value = max(0, new_value)

    label.text = str(current_value)

func increment() -> void:
    set_value(current_value + 1)

func decrement() -> void:
    set_value(current_value - 1)
