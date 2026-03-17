extends MenuButton

@export
var popup_panel_override: StyleBoxFlat

@export
var popup_font_size_overide: int

@export
var popup_item_start_padding_overide: int

@export
var popup_item_end_padding_overide: int

@export
var popup_hseparation_overide: int

var popup_menu: PopupMenu
var previous_index: int = 0

var _loaded_locales_codes: PackedStringArray

var _language_UI = {
    "en": "LANG_EN",
    "es": "LANG_ES",
    "ja": "LANG_JA",
    "ca": "LANG_CA",
}

func _ready() -> void:
    popup_menu = get_popup()

    if not popup_menu:
        return

    _style_popup_menu()

    popup_menu.id_pressed.connect(_on_language_selected)

    var current_locale = TranslationServer.get_locale()
    print(current_locale)

    _loaded_locales_codes = TranslationServer.get_loaded_locales()

    var index := 0
    for locale_code in _loaded_locales_codes:
        popup_menu.add_check_item(_language_UI[locale_code], index)


        if current_locale.contains(locale_code):
            previous_index = index
            popup_menu.toggle_item_checked(index)

        index += 1

func _on_language_selected(index: int) -> void:
    TranslationServer.set_locale(_loaded_locales_codes[index])
    popup_menu.toggle_item_checked(previous_index)
    previous_index = index
    popup_menu.toggle_item_checked(index)

func _style_popup_menu() -> void:
    popup_menu.add_theme_font_size_override("font_size", popup_font_size_overide)
    popup_menu.add_theme_constant_override("item_start_padding", popup_item_start_padding_overide)
    popup_menu.add_theme_constant_override("item_end_padding", popup_item_end_padding_overide)
    popup_menu.add_theme_constant_override("hseparation", popup_hseparation_overide)

    popup_menu.add_theme_stylebox_override("panel", popup_panel_override)
