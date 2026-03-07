extends Area2D

@export
var next_scene_name: String

@export
var player_spawn_position: Vector2

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        SceneManager.change_scene_to(next_scene_name, player_spawn_position)

