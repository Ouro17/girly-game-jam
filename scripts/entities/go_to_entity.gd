class_name GoToEntity
extends CharacterBody2D

signal target_reached(entity : GoToEntity)

@export
var movement_threshold : float

@export
var sprite : Sprite2D

@export
var idle_wobble_strength: float

@export
var idle_wobble_speed: float

var wobble_time: float = 0.0
var speed : float = 0
var target_position: Vector2
var is_going_to_target : bool
var id : int

func flip()->void:
    sprite.flip_h = ! sprite.flip_h

func set_id(new_id:int)->void:
    id = new_id

func _ready() -> void:
    target_position = global_position
    is_going_to_target = false
    wobble_time += randf_range(0.0, 10.0)

func _physics_process(delta: float) -> void:
    if global_position.distance_to(target_position) > movement_threshold:
        velocity = global_position.direction_to(target_position) * speed
    else:
        velocity = Vector2.ZERO
        if is_going_to_target:
            is_going_to_target = false
            target_position = global_position
            target_reached.emit(self)

    wobble_time += delta

    if velocity == Vector2.ZERO:
        velocity += _idle_wobble()

    move_and_slide()

func set_target(new_value : Vector2, with_speed : float) -> void:
    speed = with_speed
    target_position = new_value
    is_going_to_target = true

func _idle_wobble() -> Vector2:
    return Vector2(
        sin(wobble_time * idle_wobble_speed),
        cos(wobble_time * idle_wobble_speed)
    ) * idle_wobble_strength