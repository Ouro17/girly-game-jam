extends CharacterBody2D
class_name Fairy

signal body_entered(body : Node2D)

@export
var speed: float

@export
var movement_threshold: float

@export
var input_enabled: bool

@export
var area : Area2D

var target_position: Vector2

func _ready() -> void:
    target_position = global_position
    area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    body_entered.emit(body)

func _input(event: InputEvent) -> void:
    if not input_enabled:
        return

    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if get_viewport().gui_get_focus_owner() == null:
            var target = get_global_mouse_position()
            target_position = target

func _physics_process(_delta: float) -> void:
    if global_position.distance_to(target_position) > movement_threshold:
        velocity = global_position.direction_to(target_position) * speed
    else:
        velocity = Vector2.ZERO

    move_and_slide()