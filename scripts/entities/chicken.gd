class_name Chicken
extends CharacterBody2D

@export
var container : Node2D

@export
var speed : float

@export
var timer_range : Vector2

@export
var cooldown : float

@export
var egg_scene : PackedScene

var movement_area : Area2D
var timer : Timer
var enabled : bool

var timer_set : bool

func set_enable(value : bool) -> void:
    enabled = value

func set_area(new_area : Area2D) -> void:
    movement_area = new_area

func _ready():
    timer = Timer.new()
    timer.one_shot = true
    timer.timeout.connect(_on_time_out)
    add_child(timer)

func _process(_delta: float) -> void:
    if not enabled:
        return

    if not timer_set and timer.is_stopped():
        timer_set = true
        var time = randf_range(timer_range.x, timer_range.y)
        timer.start(time)

func _physics_process(_delta: float) -> void:
    if not enabled:
        return

    var x = randi_range(-1, 1)
    var y = randi_range(-1, 1)

    velocity = Vector2(x * speed, y * speed)

    move_and_slide()


func _on_time_out() -> void:
    print("egg")
    var egg = egg_scene.instantiate()

    egg.set_texture(randi_range(0, 2))
    # timer_set color
    container.add_child(egg)
    egg.global_position = global_position
    timer_set = false
