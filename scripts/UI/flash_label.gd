class_name FlashLabel
extends Label

@export
var flash_interval: float

@export
var loops: int

@export
var auto_start : bool

var tween : Tween

func _ready():
    if auto_start:
        start_flashing()

func start_flashing() -> void:
    tween = create_tween()
    tween.tween_property(self, "modulate:a", 1.0, flash_interval)
    tween.tween_property(self, "modulate:a", 0.0, flash_interval)
    tween.set_trans(Tween.TRANS_BOUNCE)
    tween.set_loops(loops)