extends VBoxContainer

const SPECIAL_COLOR = "#ffc000"

var notificationPrefab = preload("res://UI/Notifications/Notification.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addNotification(text : String) -> void:
    var newNotification = notificationPrefab.instance()
    newNotification.init(text)
    add_child(newNotification)

func colorSpecial(text: String, color : String) -> String:
    return "[color=%s]%s[/color]" % [color, text]

func addItemNotification(itemId : String, added = true) -> void:
    var itemName = Items.ITEMS[itemId]["name"]
    if added:
        addNotification("Acquired %s!" % colorSpecial(itemName, SPECIAL_COLOR))
    else:
        addNotification("Lost %s!" % colorSpecial(itemName, SPECIAL_COLOR))