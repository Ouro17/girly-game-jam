extends Node

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("quit"):
        SceneManager.change_scene_to(&"res://scenes/levels/menu.tscn")
        # get_tree().quit() # DEBUG ONLY