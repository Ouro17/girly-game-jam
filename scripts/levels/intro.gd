extends Node2D

enum Entities {
    Girl = 0,
    Fairy1 = 1,
    Fairy2 = 2,
    Fairy3 = 3,
}

enum Stage {
    MOVE_GIRL
}

@export
var next_level: String

@export
var flash_label : FlashLabel

@export
var dialog_cloud : TextureRect

@export
var entities: Array[GoToEntity]

@export
var markers: Array[Marker2D]

@export
var first_dialog: Dialog

@export
var last_dialog: Dialog

var current_dialog: Dialog

var current_stage: Stage

func _ready() -> void:
    current_dialog = first_dialog
    last_dialog.dialog_finished.connect(_on_dialog_finished)

    for index in range(0, entities.size()):
        entities[index].set_id(index)

    var girl = entities[Entities.Girl]

    current_stage = Stage.MOVE_GIRL

    girl.set_target(markers[Entities.Girl].global_position, 100)

    girl.target_reached.connect(_on_target_reached)

func _on_target_reached(entity: GoToEntity) -> void:
    if current_stage == Stage.MOVE_GIRL and entity.id == Entities.Girl:
        dialog_cloud.visible = true
        current_dialog.start_dialog()
        flash_label.visible = true
        flash_label.start_flashing()

func _on_dialog_finished(dialog: Dialog) -> void:
    if dialog == last_dialog:
        dialog_cloud.visible = false
        _next_level()

func _input(event):
    if event is InputEventKey and event.pressed:
        get_viewport().set_input_as_handled()
        if current_dialog != null:
            current_dialog = current_dialog.start_next_dialog()

func _next_level() -> void:
    SceneManager.change_scene_to(next_level)