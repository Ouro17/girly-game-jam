class_name IntroEntry
extends Resource

@export
var entity: int

var current_position: int

@export
var positions: Array[Vector2]

func init():
    current_position = -1

func add_position(new_positions: Vector2) -> void:
    positions.append(new_positions)

func next_position() -> Vector2:
    current_position = clamp(current_position + 1, 0, positions.size() - 1)

    return positions[current_position]
