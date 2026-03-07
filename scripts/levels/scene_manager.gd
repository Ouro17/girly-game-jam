extends Node

var player_spawn_position: Vector2
var is_setting_player_position : bool

func change_scene_to(next_level_name: String, set_player_position: bool = false, next_level_position: Vector2 = Vector2.ZERO):
    var next_level = load(next_level_name)
    player_spawn_position = next_level_position
    is_setting_player_position = set_player_position
    get_tree().change_scene_to_packed.bind().call_deferred(next_level)