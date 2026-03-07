class_name State
extends Resource

@export
var id : String

func load_state(default: Variant) -> Variant:
    if not id.is_empty():
        return GlobalState.get_key(id, default)

    return default

func save_state(value: Variant) -> void:
    if not id.is_empty():
        GlobalState.set_key(id, value)
