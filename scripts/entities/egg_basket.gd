class_name EggBasket
extends Area2D

signal correct_color_received(color : int, correct : bool)

@export
var target_color : int

func receive_egg(egg : Egg) -> void:
    correct_color_received.emit(target_color, target_color == egg.egg_color)
