class_name TaskList
extends Panel

@export
var task_items : Array[CheckBox]

func set_task(index : int, value : bool) -> void:
    if index < 0 or index >= task_items.size():
        return

    var task = task_items[index]
    task.button_pressed = value
