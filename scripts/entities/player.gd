extends CharacterBody2D
class_name Player

@export
var speed : float

@export
var movement_threshold: float

var target_position : Vector2

@export
var input_enabled : bool

func _ready() -> void:
    target_position = position

func _input(event: InputEvent ) -> void:
    if not input_enabled:
        return

    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if get_viewport().gui_get_focus_owner() == null:
            var target = get_global_mouse_position()
            target_position = target

func _physics_process(_delta: float) -> void:
    if global_position.distance_to(target_position) > movement_threshold:
        velocity = global_position.direction_to(target_position) * speed
        move_and_slide()

