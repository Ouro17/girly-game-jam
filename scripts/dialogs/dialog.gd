class_name Dialog
extends Label

signal dialog_finished(dialog : Dialog)

@export
var next_dialog : Dialog

@export
var dialog_cloud : TextureRect

@export
var time_out : float

var timer : Timer

func start_dialog() -> void:
    visible = true
    dialog_cloud.visible = true
    if time_out > 0:
        timer = Timer.new()
        timer.one_shot = true
        timer.timeout.connect(_on_time_out)
        add_child(timer)
        timer.start(time_out)

func start_next_dialog() -> Dialog:
    visible = false
    dialog_cloud.visible = false
    dialog_finished.emit(self)

    if next_dialog != null:
        next_dialog.start_dialog()

    return next_dialog

func _on_time_out() -> void:
    start_next_dialog()
