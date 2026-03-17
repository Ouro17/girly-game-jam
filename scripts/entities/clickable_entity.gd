extends Node

@export
var clickable_area : ClickableArea

@export
var sound: AudioStreamPlayer

func _ready():
    clickable_area.clicked.connect(_on_clicked)

func _on_clicked() -> void:
    if not sound.playing:
        sound.play()

