class_name Mole
extends CharacterBody2D

enum MoleState {
    Walk,
    PickUp,
    Peek,
    Angry
}

const ANIMATION_WALKING := &"walk"
const ANIMATION_PICKING := &"pick_up"
const ANIMATION_PEEKING := &"peek"
const ANIMATION_ANGRY := &"angry"

signal removing

@export
var speed: float

@export
var movement_threshold: float

@export
var navigation_agent: NavigationAgent2D

@export
var sprite: Sprite2D

@export
var animation_player: AnimationPlayer

@export
var time_to_peek: Vector2

@export
var time_to_walk: Vector2

@export
var angry_time: Vector2

@export
var pick_up_time: Vector2

@export
var mole_area : MoleArea

var target_position: Vector2
var is_movement_enabled: bool

var timer: Timer
var timer_set: bool

var current_state: MoleState

var navigation_map: RID
var vegetable : Vegetable

func _start_timer(time_range: Vector2) -> void:
    timer.start(randf_range(time_range.x, time_range.y))

func enable_movement(value: bool) -> void:
    is_movement_enabled = value

func set_navigation_map(new_value: NavigationRegion2D) -> void:
    navigation_map = new_value.get_navigation_map()
    navigation_agent.set_navigation_map(navigation_map)

func set_vegetable(new_value : Vegetable) -> void:
    vegetable = new_value
    target_position = new_value.global_position
    navigation_agent.target_position = target_position

func _ready():
    mole_area.clicked.connect(_on_clicked)

    current_state = MoleState.Walk
    navigation_agent.velocity_computed.connect(_on_velocity_computed)
    navigation_agent.navigation_finished.connect(_start_picking_up)

    timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    add_child(timer)

    _start_timer(time_to_peek)

func _physics_process(_delta: float) -> void:
    if not is_movement_enabled:
        return

    var proposed_velocity = Vector2.ZERO

    if current_state == MoleState.Walk:
        if not navigation_agent.is_target_reached():
            var next_path_position: Vector2 = navigation_agent.get_next_path_position()
            var direction: Vector2 = (next_path_position - global_position).normalized()

            _update_facing(direction)

            proposed_velocity = direction * speed

    navigation_agent.set_velocity(proposed_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
    if not is_movement_enabled:
        velocity = Vector2.ZERO
        move_and_slide()
        return

    velocity = safe_velocity
    move_and_slide()

func _stop_navigation() -> void:
    navigation_agent.set_velocity(Vector2.ZERO)
    navigation_agent.target_position = global_position
    velocity = Vector2.ZERO

func _start_picking_up() -> void:
    if current_state != MoleState.Walk:
        return

    timer.stop()
    current_state = MoleState.PickUp
    animation_player.play(ANIMATION_PICKING)
    vegetable.start_pulling()
    _start_timer(pick_up_time)

func _update_facing(direction: Vector2) -> void:
    if abs(direction.x) > 0.1:
        sprite.flip_h = direction.x > 0

func _on_time_out() -> void:
    if current_state == MoleState.Walk:
        current_state = MoleState.Peek
        enable_movement(false)
        _stop_navigation()
        animation_player.play(ANIMATION_PEEKING)
        _start_timer(time_to_walk)
    elif current_state == MoleState.Peek:
        current_state = MoleState.Walk
        animation_player.play(ANIMATION_WALKING)
        set_vegetable(vegetable)
        enable_movement(true)
        _start_timer(time_to_peek)
    elif current_state == MoleState.Angry:
        vegetable.is_target = false
        removing.emit()
        queue_free()
    elif current_state == MoleState.PickUp:
        vegetable.visible = false
        removing.emit()
        queue_free()

func _on_clicked() -> void:
    if current_state == MoleState.Walk or current_state == MoleState.Angry:
        return

    vegetable.stop()
    timer.stop()
    current_state = MoleState.Angry
    animation_player.play(ANIMATION_ANGRY)
    _start_timer(angry_time)
