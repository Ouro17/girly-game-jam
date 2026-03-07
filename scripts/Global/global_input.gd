extends Node

# func _ready() -> void:
#     var language = "automatic"
#     # Load here language from the user settings file
#     if language == "automatic":
#         var preferred_language = OS.get_locale_language()
#         TranslationServer.set_locale(preferred_language)
#     else:
#         TranslationServer.set_locale(language)

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("quit"):
        get_tree().quit()

    elif Input.is_action_just_pressed("reset"):
        get_tree().reload_current_scene()