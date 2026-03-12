class_name GoToEntity
extends CharacterBody2D

signal target_reached(entity : GoToEntity)

@export
var movement_threshold : float

@export
var sprite : Sprite2D

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

func _physics_process(_delta: float) -> void:
    if global_position.distance_to(target_position) > movement_threshold:
        velocity = global_position.direction_to(target_position) * speed
    else:
        velocity = Vector2.ZERO
        if is_going_to_target:
            is_going_to_target = false
            target_position = global_position
            target_reached.emit(self)

    move_and_slide()

func set_target(new_value : Vector2, with_speed : float) -> void:
    speed = with_speed
    target_position = new_value
    is_going_to_target = true