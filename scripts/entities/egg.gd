class_name Egg
extends Area2D

@export
var sprite: Sprite2D

@export
var textures: Array[Texture2D]

var egg_color: int

var is_dragging: bool
var drag_offset: Vector2

func _ready() -> void:
    is_dragging = false

# Specific input event when there is an area involved
func _input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            is_dragging = true
            z_index = 100
            drag_offset = global_position - get_global_mouse_position()
        elif is_dragging:
                is_dragging = false
                _check_drop_area()


func _process(_delta: float) -> void:
    if is_dragging:
        global_position = get_global_mouse_position() + drag_offset

func _check_drop_area() -> void:
    var overlapping_areas := get_overlapping_areas()

    for area in overlapping_areas:
        if area is EggBasket:
            area.receive_egg(self)
            queue_free()

func set_texture(index: int) -> void:
    if index < 0 or index >= textures.size():
        return

    sprite.texture = textures[index]
    egg_color = index