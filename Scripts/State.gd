extends Node

var GIKOCOIN_CHANCE = 0.1
var rng = RandomNumberGenerator.new()


var date = Constants.TIME_START

## activity state
var totalActivity = 0
var activityBreakpoint: int = 0
var activityEarned: int = 0
var upgradeReady: bool = false

## game state
var serverSize = 10000
var gikosSpawnedOnClick = 1
var activityMultiplier = 1
var autoSpawnTime = 0

## upgrade state
var pickedUpgrades = []
var upgradePool = []
var availableUpgrades = []

var buildableObjects = Constants.BuildData
onready var camera = get_node("/root/Main/Camera2D")


func regenAvailableUpgrades(num: int = 3) -> void:
	## upgrade pool must have been regen'd before
	var tempUpg = []
	var tempPool = upgradePool
	var actualNum = min(upgradePool.size(), num)
	for i in range(actualNum):
		var randomIndex = rng.randi() % tempPool.size()
		tempUpg.append(tempPool[randomIndex])
		tempPool.remove(randomIndex)
	availableUpgrades = tempUpg


func regenUpgradePool() -> void:
	var tempPool = []
	for upgrade in Upgrade.UPGRADE_DATA:
		if not (upgrade in pickedUpgrades):
			var prereqs_fulfilled = true
			for prereq in Upgrade.UPGRADE_DATA[upgrade]["unlockedBy"]:
				if not (prereq in pickedUpgrades):
					prereqs_fulfilled = false
					break
			if prereqs_fulfilled:
				tempPool.append(upgrade)
	upgradePool = tempPool

func pickUpgrade(upgradeId : int) -> void:
	pickedUpgrades.append(upgradeId)
	upgradeReady = false
	activityBreakpoint += 1
	regenUpgradePool()
	regenAvailableUpgrades()
	applyUpgrade(upgradeId)

func applyUpgrade(upgradeId : int ) -> void:
	var upgradeData = Upgrade.UPGRADE_DATA[upgradeId]
	var upgradeType = upgradeData["type"]
	match upgradeType:
		Upgrade.UpgradeType.BetterClicks:
			gikosSpawnedOnClick += upgradeData["data"]
		Upgrade.UpgradeType.BiggerServer:
			serverSize += upgradeData["data"]
		Upgrade.UpgradeType.ActivityBreakpoint:
			activityMultiplier -= upgradeData["data"]
		Upgrade.UpgradeType.AutoSpawn:
			autoSpawnTime = upgradeData["data"]

func _ready():
	rng.randomize()
	regenUpgradePool()
	regenAvailableUpgrades()

func getActivityRequired() -> int:
	return Constants.ACTIVITY_BREAKPOINTS[activityBreakpoint] * activityMultiplier

func addActivity(more: int) -> void:
	totalActivity += more
	activityEarned += more
	if getActivityRequired() <= activityEarned:
		upgradeReady = true
		
func _process(delta):
    date += delta * Constants.TIME_SCALE
