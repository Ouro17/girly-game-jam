class_name MiniGame1
extends Node2D

@export
var mini_game_intro : MiniGameIntro

@export
var victory_sound : AudioStreamPlayer

@export
var music : AudioStreamPlayer

@export
var timer_range : Vector2

@export
var falling_elements : Array[PackedScene]

@export
var from : Node2D

@export
var collision_shape : CollisionShape2D

@export
var outlimits : Area2D

@export
var fairy : Fairy

@export
var number_holder : NumberHolder

@export
var next_level: String

@export
var first_dialog : Dialog

@export
var last_dialog : Dialog

@export
var state : State

var timer : Timer
var game_enabled

func _ready() -> void:
    mini_game_intro.intro_finished.connect(_on_intro_finished)
    last_dialog.dialog_finished.connect(_on_dialog_finished)
    outlimits.body_entered.connect(_on_out_of_limits)

    game_enabled = false

    fairy.body_entered.connect(_on_body_entered)

    timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    add_child(timer)

func start_timer() -> void:
    timer.start(randf_range(timer_range.x, timer_range.y))

func get_random_point_in_area() -> Vector2:
    var rectangle := collision_shape.shape as RectangleShape2D

    var half_size := rectangle.size * 0.5

    var random_local_position := Vector2(
        randf_range(-half_size.x, half_size.x),
        randf_range(-half_size.y, half_size.y)
    )

    return collision_shape.global_transform * random_local_position

func spawn(index : int) -> void:
    if index < 0 or index >= falling_elements.size():
        return

    var instance = falling_elements[index].instantiate()

    if instance != null:
        from.add_child(instance)
        instance.global_position = get_random_point_in_area()

func _on_intro_finished() -> void:
    mini_game_intro.visible = false
    first_dialog.start_dialog()
    fairy.input_enabled = true
    game_enabled = true
    start_timer()

func _level_complete(result : bool)-> void:
    _save_state(result)

    EventBus.observers.emit(state.id)

    SceneManager.change_scene_to(next_level)

func _save_state(value: bool) -> void:
    if state != null:
        return state.save_state(value)

func _on_dialog_finished(dialog : Dialog) -> void:
    if dialog == last_dialog:
        _level_complete(true)

func _on_out_of_limits(body : Node2D) -> void:
    body.queue_free()

func _on_body_entered(body : Node2D) -> void:
    if body is FallingEntity:
        if body.is_bad:
            number_holder.decrement()
        else:
            number_holder.increment()

    if number_holder.is_max_value_reached:
        game_enabled = false
        victory_sound.play()
        music.stop()
        last_dialog.start_dialog()

    body.queue_free()

func _on_time_out() -> void:
    if game_enabled:
        spawn(randi_range(0, falling_elements.size() - 1))

    start_timer()
