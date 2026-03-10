extends CharacterBody2D
class_name Player

@export
var speed: float

@export
var movement_threshold: float

@export
var idle_wobble_strength: float

@export
var idle_wobble_speed: float

@export
var input_enabled: bool

var target_position: Vector2
var wobble_time: float = 0.0

func _ready() -> void:
    target_position = global_position

func _input(event: InputEvent) -> void:
    if not input_enabled:
        return

    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if get_viewport().gui_get_focus_owner() == null:
            var target = get_global_mouse_position()
            target_position = target

func _physics_process(delta: float) -> void:
    if global_position.distance_to(target_position) > movement_threshold:
        velocity = global_position.direction_to(target_position) * speed
    else:
        wobble_time += delta
        velocity = _idle_wobble()

    move_and_slide()


func _idle_wobble() -> Vector2:
    return Vector2(
        sin(wobble_time * idle_wobble_speed),
        cos(wobble_time * idle_wobble_speed)
    ) * idle_wobble_strength
