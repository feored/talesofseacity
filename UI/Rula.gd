extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for room in Rooms.ROOMS.keys():
		$"%RulaRooms".add_item(Rooms.DISPLAY_NAMES[room])


func show() -> void:
	visible = true

func hide() -> void:
	visible = false

func _on_CloseBtn_pressed():
	visible = false
