extends PanelContainer

const spacer = 10

var ItemDisplayPrefab = preload("res://Items/ItemDisplay.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	reloadInventory()
	

func _input(event):
	if event.is_action_pressed("inventory"):
		showInventory(!visible)

func showInventory(show : bool) -> void:
	visible = show
	if (visible && Items.inventoryRefreshNeeded):
		reloadInventory()
	if (!visible):
		hidePopup()

func showPopup(item : Dictionary) -> void:
	## calc where to show popup
	$"%InventoryPopup".setItem(item)
	$"%InventoryPopup".show()
	var mousePos = get_global_mouse_position()
	var windowSize = OS.window_size
	var rectSize = $"%InventoryPopup".rect_size
	
	var finalPos = Vector2()

	if (mousePos.x < windowSize.x/2):
		finalPos.x = mousePos.x + spacer
	else:
		finalPos.x = mousePos.x - rectSize.x - spacer

	if (mousePos.y < windowSize.y/2):
		finalPos.y = mousePos.y + spacer * 2
	else:
		finalPos.y = mousePos.y - rectSize.y - spacer * 2

	
	$"%InventoryPopup".rect_global_position = finalPos


func hidePopup() -> void:
	$"%InventoryPopup".hide()

func reloadInventory() -> void:
	## clear current inv first
	for node in $"%InvItems".get_children():
		node.queue_free()
	for itemInv in Items.INVENTORY:
		var itemDisplay = ItemDisplayPrefab.instance()
		itemDisplay.setItem(Items.ITEMS[itemInv])
		itemDisplay.showPopup = funcref(self, "showPopup")
		itemDisplay.hidePopup = funcref(self, "hidePopup")
		$"%InvItems".add_child(itemDisplay)
	Items.inventoryRefreshNeeded = false
