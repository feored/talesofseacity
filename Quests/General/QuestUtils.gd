extends Node
var blackoutPrefab = preload("res://Quests/Misc/Blackout.tscn")
var flashlightPrefab = preload("res://Quests/Misc/Flashlight.tscn")
onready var main = get_node("/root/Main")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func blackout(blackout : bool = true) -> void:
	if blackout:
		var blackoutNode = blackoutPrefab.instance()
		main.playerGiko.add_child(blackoutNode)


func flashlight() -> void:
	var flashlightNode = flashlightPrefab.instance()
	main.playerGiko.add_child(flashlightNode)


func earthquake() -> void:
	var tween = create_tween()
	main.get_node("%Camera2D").shake(5, 10)
	tween.tween_callback(self, "blackout").set_delay(4)
