class_name MiniGameIntro
extends CanvasLayer

signal intro_finished

@export
var wait_time : float

func _ready() -> void:
    var timer := Timer.new()
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    add_child(timer)
    timer.start(wait_time)

func _on_time_out() -> void:
    intro_finished.emit()
