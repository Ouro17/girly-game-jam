class_name LevelEntrance
extends Area2D

signal player_on_entrance(level : int, value: bool)

@export
var next_level : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)


func _on_body_entered(body : Node2D) -> void:
    _handle_body(body, true)

func _on_body_exited(body : Node2D) -> void:
    _handle_body(body, false)

func _handle_body(body : Node2D, value : bool) -> void:
    if body is Player:
        player_on_entrance.emit(next_level, value)