extends Sprite2D

@export
var leader: Node2D

@export
var max_radius: float

@export
var follow_strength: float

func _ready() -> void:
    # Make sure it draws behind the leader
    z_index = leader.z_index - 1

func _process(delta: float) -> void:
    if leader == null:
        return

    var to_leader: Vector2 = leader.global_position - global_position
    global_position += to_leader * follow_strength * delta

    var position_offset: Vector2 = global_position - leader.global_position

    var dist := position_offset.length()
    if dist > max_radius:
        position_offset = position_offset.normalized() * max_radius
        global_position = leader.global_position + position_offset
