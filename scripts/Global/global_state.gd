extends Node

var dictionary: Dictionary[String, Variant] = {}

## Set the key with a value
## If the key was already, it modify it
## Return true or false if the operation was correct
func set_key(key: String, value: Variant) -> bool:
    if key.is_empty():
        printerr("The key is empty and it's trying to use global state")
        return false

    dictionary[key] = value
    return true

## Set the key with a value
## If the key was missing, returns default
## On error, return default value
func get_key(key:String, default_value: Variant = null) -> Variant:
    if key.is_empty():
        printerr("The key is empty and it's trying to use global state")
        return default_value

    return dictionary.get(key, default_value)

## Remove the key from the global state
## Returns true if successful
func remove_key(key: String) -> bool:
    return dictionary.erase(key)
