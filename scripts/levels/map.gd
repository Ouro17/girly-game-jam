extends Node2D

@export
var next_levels: Array[String]

@export
var end_map_label : EndMapLabel

@export
var events_observer : Array[EventObserver]

@export
var task_list : TaskList

@export
var level_entrances : Array[LevelEntrance]

var levels_done = 0

func _ready() -> void:
    if end_map_label != null:
        end_map_label.done.connect(_on_end_fired)

    if level_entrances != null:
        for level_entrance in level_entrances:
            level_entrance.player_on_entrance.connect(_on_player_on_entrance)

    _check_game_events()

    if events_observer != null and not events_observer.is_empty() and not EventBus.observers.is_connected(observing):
        EventBus.observers.connect(observing)

func observing(received_id: String) -> void:
    for index in range(events_observer.size()):
        var event = events_observer[index]
        if event.event_id != received_id:
            continue

        if  event.check_event(events_observer):
            _mark_level_as_done(index)

func _on_player_on_entrance(next_level: int, value : bool) -> void:
    if value:
        _next_level(next_level)

func _on_end_fired()->void:
    _next_level(next_levels.size() - 1) # Last level is outro always

func _next_level(index : int)-> void:
    if index >= 0 and index < next_levels.size():
        SceneManager.change_scene_to(next_levels[index])

func _mark_level_as_done(index : int) -> void:
    if task_list != null:
        task_list.set_task(index, true)

    levels_done += 1

    if levels_done == events_observer.size():
        end_map_label.start_timer()

func _check_game_events() -> void:
    if events_observer == null:
        return

    for event_index in range(events_observer.size()):
        var event = events_observer[event_index]
        if event.check_event(events_observer):
            _mark_level_as_done(event_index)
