class_name MiniGameIntro
extends CanvasLayer

signal intro_finished

@export
var timer : Timer

func _ready() -> void:
    timer.timeout.connect(_on_time_out)

func _on_time_out() -> void:
    intro_finished.emit()
