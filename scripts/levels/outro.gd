extends Node2D

enum Entities {
    Girl = 0,
    Fairy_0 = 1,
    Fairy_1 = 2,
    Fairy_2 = 3,
}

enum Stage {
    MOVE_FAIRIES_0,
    MOVE_GIRL,
    MOVE_FAIRIES_1,
    END
}

@export
var next_level: String

@export
var flash_label: FlashLabel

@export
var dialog_cloud: TextureRect

@export
var entries : Array[IntroEntry]

@export
var entities: Array[GoToEntity]

@export
var girl_markers: Array[Marker2D]

@export
var fairy_0: Array[Marker2D]

@export
var fairy_1: Array[Marker2D]

@export
var fairy_2: Array[Marker2D]

@export
var dialogs : Array[Dialog]

var current_dialog: Dialog

var current_stage: Stage

const FAIRY_MOVEMENT = 300
const GIRL_MOVEMENT = 200

func get_markers(index : Entities) -> Array[Marker2D]:
    match index:
        Entities.Girl:
            return girl_markers
        Entities.Fairy_0:
            return fairy_0
        Entities.Fairy_1:
            return fairy_1
        Entities.Fairy_2:
            return fairy_2

    return girl_markers

func _ready() -> void:
    current_dialog = dialogs[0]

    for dialog in dialogs:
        dialog.dialog_finished.connect(_on_dialog_finished)

    for index in range(0, entities.size()):
        entities[index].set_id(index)

    for index in range(0, entries.size()):
        var entry = entries[index]
        entry.init()
        var markers = get_markers(index)
        for marker in markers:
            entry.add_position(marker.global_position)

    current_stage = Stage.MOVE_FAIRIES_0

    entities[Entities.Fairy_0].set_target(entries[Entities.Fairy_0].next_position(), FAIRY_MOVEMENT)
    entities[Entities.Fairy_1].set_target(entries[Entities.Fairy_1].next_position(), FAIRY_MOVEMENT)
    entities[Entities.Fairy_2].set_target(entries[Entities.Fairy_2].next_position(), FAIRY_MOVEMENT)

    entities[Entities.Fairy_2].target_reached.connect(_on_target_reached)

func _on_target_reached(entity: GoToEntity) -> void:
    if current_stage == Stage.MOVE_FAIRIES_0 and entity.id == Entities.Fairy_2:
        entities[Entities.Fairy_1].flip()
        entities[Entities.Fairy_2].flip()
        dialog_cloud.visible = true
        current_dialog.start_dialog()
        flash_label.visible = true
        flash_label.start_flashing()
        current_stage = Stage.MOVE_GIRL

func _on_dialog_finished(dialog: Dialog) -> void:
    if dialog == dialogs[dialogs.size() - 1]:
        dialog_cloud.visible = false
        flash_label.visible = false
        _next_level()

    elif current_stage == Stage.MOVE_GIRL and dialog == dialogs[3]:
        entities[Entities.Fairy_0].flip()
        entities[Entities.Girl].set_target(entries[Entities.Girl].next_position(), GIRL_MOVEMENT)
        current_stage = Stage.MOVE_FAIRIES_1

    elif current_stage == Stage.MOVE_FAIRIES_1 and dialog == dialogs[8]:
        entities[Entities.Fairy_0].flip()
        entities[Entities.Fairy_1].flip()
        entities[Entities.Fairy_2].flip()

        entities[Entities.Fairy_0].set_target(entries[Entities.Fairy_0].next_position(), FAIRY_MOVEMENT)
        entities[Entities.Fairy_1].set_target(entries[Entities.Fairy_1].next_position(), FAIRY_MOVEMENT)
        entities[Entities.Fairy_2].set_target(entries[Entities.Fairy_2].next_position(), FAIRY_MOVEMENT)
        current_stage = Stage.END

func _input(event):
    if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
        get_viewport().set_input_as_handled()
        if current_dialog != null:
            current_dialog = current_dialog.start_next_dialog()

func _next_level() -> void:
    SceneManager.change_scene_to(next_level)
