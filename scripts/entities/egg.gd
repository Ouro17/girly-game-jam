class_name Egg
extends Area2D

@export
var sprite: Sprite2D

@export
var textures: Array[Texture2D]

@export
var time_to_disappear: Vector2

var egg_color: int

var is_dragging: bool
var drag_offset: Vector2

static var current_dragged_egg: Egg = null

var timer: Timer
var time_left : float

func _ready() -> void:
    is_dragging = false

    timer = Timer.new()
    add_child(timer)
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    timer.start(randf_range(time_to_disappear.x, time_to_disappear.y))

func _on_time_out() -> void:
    queue_free()

# Specific input event when there is an area involved
func _input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            if current_dragged_egg != null:
                return

            time_left = timer.time_left
            timer.stop()
            current_dragged_egg = self
            is_dragging = true
            z_index = 100
            drag_offset = global_position - get_global_mouse_position()
        elif is_dragging:
            current_dragged_egg = null
            is_dragging = false
            _check_drop_area()


func _process(_delta: float) -> void:
    if is_dragging:
        global_position = get_global_mouse_position() + drag_offset

func _check_drop_area() -> void:
    var overlapping_areas := get_overlapping_areas()

    var queued := false
    for area in overlapping_areas:
        if area is EggBasket:
            area.receive_egg(self)
            queued = true
            queue_free()

    if not queued:
        timer.start(time_left)

func set_texture(index: int) -> void:
    if index < 0 or index >= textures.size():
        return

    sprite.texture = textures[index]
    egg_color = index