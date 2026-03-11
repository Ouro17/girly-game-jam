class_name MiniGame0
extends Node2D

@export
var mini_game_intro : MiniGameIntro

@export
var movement_area: NavigationRegion2D

@export
var chickens : Array[Chicken]

@export
var egg_baskets : Array[EggBasket]

@export
var number_holders : Array[NumberHolder]

@export
var next_level: String

@export
var first_dialog : Dialog

@export
var last_dialog : Dialog

@export
var state : State

var fill_baskets : Array[bool]

func _ready() -> void:
    mini_game_intro.intro_finished.connect(_on_intro_finished)

    for chicken in chickens:
        chicken.set_area(movement_area)

    for basket in egg_baskets:
        basket.correct_color_received.connect(_on_egg_received)
        fill_baskets.append(false)

    last_dialog.dialog_finished.connect(_on_dialog_finished)

func _on_intro_finished() -> void:
    mini_game_intro.visible = false
    for chicken in chickens:
        chicken.set_enable(true)

    first_dialog.start_dialog()

func _level_complete(result : bool)-> void:
    _save_state(result)
    EventBus.observers.emit(state.id)

    SceneManager.change_scene_to(next_level)

func _save_state(value: bool) -> void:
    if state != null:
        return state.save_state(value)

func is_true(value : bool):
    return value

func _on_egg_received(index : int, correct : bool) -> void:
    var holder = number_holders[index]

    if correct:
        holder.increment()
    else:
        holder.decrement()

    fill_baskets[index] = holder.is_max_value_reached

    if fill_baskets.all(is_true):
        last_dialog.start_dialog()

func _on_dialog_finished(dialog : Dialog) -> void:
    if dialog == last_dialog:
        _level_complete(true)