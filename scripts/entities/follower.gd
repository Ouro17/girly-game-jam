extends CharacterBody2D

@export
var leader: Node2D

@export
var other_followers: Array[CharacterBody2D]

@export
var follow_distance : float

@export
var follow_tolerance : float

@export
var speed: float

@export
var movement_threshold: float

@export
var separation_distance: float

@export
var separation_force: float

@export
var idle_wobble_strength: float

@export
var idle_wobble_speed: float

var wobble_time: float = 0.0

var max_distance : float

func _ready() -> void:
    if leader != null:
        global_position = leader.global_position
        z_index = leader.z_index - 1

    max_distance = follow_distance + follow_tolerance

func _physics_process(delta: float) -> void:
    if leader == null:
        return

    wobble_time += delta

    var direction_to_leader: Vector2 = global_position.direction_to(leader.global_position)
    var distance_to_leader: float = global_position.distance_to(leader.global_position)

    var desired_velocity: Vector2 = Vector2.ZERO

    if distance_to_leader > max_distance:
        desired_velocity = direction_to_leader * speed

    desired_velocity += _calculate_separation()

    if desired_velocity == Vector2.ZERO:
        desired_velocity += _idle_wobble()

    velocity = desired_velocity

    move_and_slide()


func _calculate_separation() -> Vector2:
    var separation_velocity: Vector2 = Vector2.ZERO

    for follower in other_followers:
        if follower == null:
            continue

        var distance_to_follower: float = global_position.distance_to(follower.global_position)

        if distance_to_follower < separation_distance:
            var push_direction: Vector2 = follower.global_position.direction_to(global_position)
            var strength: float = (separation_distance - distance_to_follower) / separation_distance

            separation_velocity += push_direction * separation_force * strength

    return separation_velocity

func _idle_wobble() -> Vector2:
    return Vector2(
        sin(wobble_time * idle_wobble_speed),
        cos(wobble_time * idle_wobble_speed)
    ) * idle_wobble_strength