class_name Egg
extends Area2D

@export
var sprite : Sprite2D

@export
var textures : Array[Texture2D]


func set_texture(index : int) -> void:
    if index < 0 or index >= textures.size():
        return

    sprite.texture = textures[index]
