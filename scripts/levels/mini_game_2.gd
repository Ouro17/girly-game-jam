class_name MiniGame2
extends Node2D

@export
var mini_game_intro : MiniGameIntro

@export
var retry_sound : AudioStreamPlayer

@export
var victory_sound : AudioStreamPlayer

@export
var music : AudioStreamPlayer

@export
var timer_range : Vector2

@export
var restock_time : float

@export
var mole_scene : PackedScene

@export
var max_moles : int

@export
var navigation_map : NavigationRegion2D

@export
var spawn_markers : Array[Marker2D]

@export
var vegetables : Array[Vegetable]

@export
var number_holder : NumberHolder

@export
var next_level: String

@export
var first_dialog : Dialog

@export
var last_dialog : Dialog

@export
var retry_dialog : Dialog

@export
var state : State

var spawn_timer : Timer
var game_enabled : bool
var current_moles : int

var countdown_timer : Timer

func _ready() -> void:
    mini_game_intro.intro_finished.connect(_on_intro_finished)
    last_dialog.dialog_finished.connect(_on_dialog_finished)
    retry_dialog.dialog_finished.connect(_on_retry_dialog_finished)

    game_enabled = false
    current_moles = 0

    spawn_timer = Timer.new()
    spawn_timer.one_shot = true
    spawn_timer.timeout.connect(_on_time_out)
    add_child(spawn_timer)

    number_holder.set_value(number_holder.max_value)

    countdown_timer = Timer.new()
    countdown_timer.one_shot = true
    countdown_timer.timeout.connect(_on_count_down)
    add_child(countdown_timer)

    for vegetable in vegetables:
        if not vegetable.visible:
            vegetable.is_target = true

func start_spawn_timer() -> void:
    spawn_timer.start(randf_range(timer_range.x, timer_range.y))

func start_count_down_timer() -> void:
    countdown_timer.start(1)

func is_target(value : Vegetable):
    return value.is_target

func spawn() -> void:
    if current_moles >= max_moles:
        return

    var vegetable : Vegetable = null
    var first_non_target = vegetables.filter(func(v : Vegetable):
        return not v.is_target
    )

    if first_non_target.size() > 0:
        vegetable = first_non_target[0]
    else:
        return

    var instance = mole_scene.instantiate()

    if instance != null:
        current_moles = min (current_moles + 1, max_moles)
        vegetable.is_target = true

        add_child(instance)

        var entry_index = randi_range(0, spawn_markers.size()-1)

        instance.global_position = spawn_markers[entry_index].global_position
        instance.set_navigation_map(navigation_map)
        instance.set_vegetable(vegetable)
        instance.enable_movement(true)

        instance.removing.connect(_on_mole_removed)

func _on_retry_dialog_finished(dialog : Dialog) -> void:
    if dialog == retry_dialog:
        game_enabled = true

func _on_mole_removed() -> void:
    current_moles = max(0, current_moles - 1)
    if game_enabled and vegetables.all(func(v : Vegetable):
        return not v.visible
    ):
        game_enabled = false
        retry_sound.play()
        retry_dialog.start_dialog()
        number_holder.set_value(number_holder.max_value)

        for vegetable in vegetables:
            vegetable.stop()
            vegetable.is_target = false
            vegetable.visible = true
            await get_tree().create_timer(restock_time).timeout



func _on_intro_finished() -> void:
    mini_game_intro.visible = false
    first_dialog.start_dialog()
    game_enabled = true
    start_spawn_timer()
    start_count_down_timer()

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

func _on_time_out() -> void:
    if game_enabled:
        spawn()

    start_spawn_timer()

func _on_count_down() -> void:
    if game_enabled:
        number_holder.decrement()
        if number_holder.current_value == 0:
            game_enabled = false
            victory_sound.play()
            music.stop()
            last_dialog.start_dialog()

    start_count_down_timer()
