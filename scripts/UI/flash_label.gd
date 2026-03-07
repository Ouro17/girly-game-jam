extends Label

@export
var flash_interval: float

@export
var loops: int

var tween : Tween

func _ready():
    tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.0, flash_interval)
    tween.tween_property(self, "modulate:a", 1.0, flash_interval)
    tween.set_trans(Tween.TRANS_BOUNCE)
    tween.set_loops(loops)