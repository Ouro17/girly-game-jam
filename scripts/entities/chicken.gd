class_name Chicken
extends CharacterBody2D

enum ChickenState {
    Idle,
    Walking,
    Laying
}

const ANIMATION_IDLE := &"idle"
const ANIMATION_WALKING := &"walk"
const ANIMATION_LAYING := &"laying"

@export
var container : Node2D

@export
var speed : float

@export
var movement_threshold : float

@export
var timer_range : Vector2

@export
var cooldown : float

@export
var egg_scene : PackedScene

@export
var navigation_agent : NavigationAgent2D

@export
var sprite : Sprite2D

@export
var animation_player : AnimationPlayer

@export
var egg_position : Marker2D

var movement_area : NavigationRegion2D
var timer : Timer
var enabled : bool

var timer_set : bool

var current_state : ChickenState

var egg_marker_base_position : Vector2

func set_enable(value : bool) -> void:
    enabled = value

func set_area(new_area : NavigationRegion2D) -> void:
    movement_area = new_area

func _ready():
    current_state = ChickenState.Idle

    timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    add_child(timer)

    egg_marker_base_position = egg_position.position

func _process(_delta: float) -> void:
    if not enabled:
        return

    if current_state == ChickenState.Idle and not timer_set and timer.is_stopped():
        timer_set = true
        timer.start(randf_range(timer_range.x, timer_range.y))

func _physics_process(_delta: float) -> void:
    if not enabled:
        return

    if current_state == ChickenState.Walking:
        if not navigation_agent.is_target_reached():
            var next_path_position : Vector2 = navigation_agent.get_next_path_position()
            var direction : Vector2 = (next_path_position - global_position).normalized()

            _update_facing(direction)

            velocity = direction * speed
        else:
            velocity = Vector2.ZERO
            _start_laying()

    move_and_slide()

func _get_next_position() -> Vector2:
    return NavigationServer2D.region_get_random_point(movement_area.get_rid(), 1, true)

func _update_facing(direction : Vector2) -> void:
    if abs(direction.x) > 0.1:
        var facing_right : bool = direction.x > 0
        sprite.flip_h = facing_right

        if facing_right:
            egg_position.position.x = -abs(egg_marker_base_position.x)
        else:
            egg_position.position.x = abs(egg_marker_base_position.x)

func _start_laying() -> void:
    current_state = ChickenState.Laying
    animation_player.play(ANIMATION_LAYING)

    timer_set = true
    timer.start(0.5)

func _on_time_out() -> void:
    if current_state == ChickenState.Idle:
        navigation_agent.target_position = _get_next_position()
        current_state = ChickenState.Walking
        animation_player.play(ANIMATION_WALKING)

    elif current_state == ChickenState.Laying and container != null:
        var egg = egg_scene.instantiate()

        if egg != null:
            egg.set_texture(randi_range(0, 2))
            container.add_child(egg)
            egg.global_position = egg_position.global_position

        current_state = ChickenState.Idle
        animation_player.play(ANIMATION_IDLE)

    timer_set = false
