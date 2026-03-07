extends Node2D

@export
var next_levels: Array[String]

@export
var timer : Timer

@export
var events_observer : Array[EventObserver]

var current_level = 0

func _ready() -> void:
    timer.timeout.connect(_on_time_out)

    _check_game_events()

    if events_observer != null and not events_observer.is_empty() and not EventBus.observers.is_connected(observing):
        EventBus.observers.connect(observing)

func observing(received_id: String) -> void:
    for event in events_observer:
        if event.event_id != received_id:
            continue

        if _check_event(event):
            _advance_level()

func _on_time_out()-> void:
    _next_level()

func _next_level()-> void:
    SceneManager.change_scene_to(next_levels[current_level])

func _advance_level() -> void:
    current_level += 1

func _check_game_events() -> void:
    var progressed : bool = true

    # Loop to respect ordering rules
    while progressed:
        progressed = false

        for event in events_observer:
            if _check_event(event):
                _advance_level()
                progressed = true

func _check_event(event : EventObserver) -> bool:
    if event.reacted_count >= event.max_reactions:
        return false

    var occurred = GlobalState.get_key(event.event_id, false)
    if not occurred:
        return false

    if not EventObserver.can_react_in_order(event, events_observer):
        return false

    event.reacted_count += 1
    return true