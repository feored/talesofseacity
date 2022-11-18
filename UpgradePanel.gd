extends Panel

const upgradePrefab = preload("res://Upgrades/Upgrade.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showUpgrades() -> void:
	for upgrade in State.availableUpgrades:
		var newUpgrade = upgradePrefab.instance()
		newUpgrade.init(upgrade)
		newUpgrade.pickUpgrade = funcref(self, "pickUpgrade")
		$Upgrades.add_child(newUpgrade)

func hideUpgrades() -> void:
	for n in $Upgrades.get_children():
		$Upgrades.remove_child(n)
		n.queue_free()

func pickUpgrade(upgradeId : int) -> void:
	State.pickUpgrade(upgradeId)
	hide()


func show() -> void:
	visible = true
	showUpgrades()

func hide() -> void:
	visible = false
	hideUpgrades()
	
func _on_UpgradeBtn_pressed():
	show()

func _on_ExitBtn_pressed():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
