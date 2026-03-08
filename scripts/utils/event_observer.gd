class_name EventObserver
extends Resource

const KEY_EVENT_ID := &"event_id"
const KEY_REACTED_COUNT := &"reacted_count"

@export
var event_id: String

@export
var order: int = 0

@export
var max_reactions: int = 1

var reacted_count: int = 0

func can_react_in_order(observer_events: Array[EventObserver]) -> bool:
    for other in observer_events:
        if other.order < order and other.reacted_count < other.max_reactions:
            return false
    return true

func get_default_state() -> Dictionary:
    if event_id.is_empty():
        return {}

    return {
        KEY_EVENT_ID: event_id,
        KEY_REACTED_COUNT: 0
    }

func get_state() -> Dictionary:
    if event_id.is_empty():
        return {}

    return {
        KEY_EVENT_ID: event_id,
        KEY_REACTED_COUNT: reacted_count
    }

func load_state(data: Dictionary) -> void:
    if not event_id.is_empty() and data.get(KEY_EVENT_ID) == event_id:
        reacted_count = data.get(KEY_REACTED_COUNT, 0)

func check_event(events_observer : Array[EventObserver]) -> bool:
    if reacted_count >= max_reactions:
        return false

    # TODO It should now know about this
    # it should be an state or something how checks
    var occurred = GlobalState.get_key(event_id, false)
    if not occurred:
        return false

    if not can_react_in_order(events_observer):
        return false

    reacted_count += 1
    return true