extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var panels : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	panels = [
		$"%Rula",
		$"%Inventory"
	]


func _input(event):
	if event.is_action_pressed("inventory"):
		$"%Inventory".show() if !$"%Inventory".visible else $"%Inventory".hide()

func hideAllPanels():
	for panel in panels:
		panel.hide()


func _on_RulaBtn_pressed():
	hideAllPanels()
	$"%Rula".show()

func _on_InventoryBtn_pressed():
	hideAllPanels()
	$"%Inventory".show()


func _on_RulaGoBtn_pressed():
	var newRoomNumber = $"%RulaRooms".get_selected_id()
	var newRoomName = $"%RulaRooms".get_item_text(newRoomNumber)
	var newRoomID = Rooms.DISPLAY_NAMES.keys()[0]
	for i in Rooms.DISPLAY_NAMES.size():
		if Rooms.DISPLAY_NAMES.values()[i] == newRoomName:
			newRoomID = Rooms.DISPLAY_NAMES.keys()[i]
			break

	var spawnPoint = Rooms.ROOMS[newRoomID]["spawnPoint"]
	var target = {
		"roomId" : newRoomID,
		"doorId" : spawnPoint
		}
	hideAllPanels()
	get_node("/root/Main").changeRoom(target)
	
