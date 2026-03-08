class_name EndMapLabel
extends Label

signal done

@export
var time_before_done : float

func start_timer()-> void:
    visible = true
    var timer = Timer.new()
    timer.timeout.connect(_on_time_out)
    timer.wait_time = time_before_done
    timer.one_shot = true
    add_child(timer)
    timer.start()

func _on_time_out() -> void:
    done.emit()
