extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    var displayRooms = []
    for room in Rooms.ROOMS.keys():
        displayRooms.push_back(Rooms.DISPLAY_NAMES[room])
    displayRooms.sort()
    for displayRoom in displayRooms:
        $"%RulaRooms".add_item(displayRoom)


func show() -> void:
    visible = true

func hide() -> void:
    visible = false

func _on_CloseBtn_pressed():
    visible = false
