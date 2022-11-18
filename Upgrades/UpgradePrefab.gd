extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var upgradeId
var pickUpgrade : Object # funcref

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_upgradeId : int) -> void:
	self.upgradeId = _upgradeId
	var upgradeData = Upgrade.UPGRADE_DATA[upgradeId]
	$Title.text = upgradeData["name"]
	$Description.text = upgradeData["description"]
	$Effect.text = upgradeData["effect"]
	
	
func _on_PickButton_pressed():
	pickUpgrade.call_func(upgradeId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
