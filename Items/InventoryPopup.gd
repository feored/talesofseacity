extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentItem : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setItem(item : Dictionary) -> void:
    currentItem = item
    updateData()

func updateData() -> void:
    $"%InventoryPopupImage".texture = load(currentItem["url"])
    $"%InventoryPopupItemName".text = currentItem["name"]
    $"%InventoryPopupDescription".text = currentItem["description"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
