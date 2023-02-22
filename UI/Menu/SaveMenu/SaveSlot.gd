extends Button

onready var slotNumber = $"%SlotNumber"
onready var nameLabel = $"%NameLabel"
onready var roomLabel = $"%RoomLabel"
onready var dateLabel = $"%DateLabel"
onready var timeLabel = $"%TimeLabel"

var slot
var saveInfo

var selected : Object # funcref

func _ready():
	self.displayData()

func displayEmpty():
	nameLabel.visible = false
	roomLabel.visible = false
	dateLabel.visible = false
	timeLabel.visible = false

func initData(inSlot: int, inSaveInfo : Dictionary):
	self.slot = inSlot
	self.saveInfo = inSaveInfo

func displayData():
	slotNumber.text = "%s" % (slot+1)
	if saveInfo.values().size() < 1:
		print("displaying empty still")
		print(saveInfo)
		displayEmpty()
	else:
		nameLabel.text = saveInfo["name"]
		roomLabel.text = saveInfo["room"]
		dateLabel.text = "%s/%s/%s" % [saveInfo["time"]["year"], saveInfo["time"]["month"], saveInfo["time"]["day"]]
		timeLabel.text = "%s:%s:%s" % [saveInfo["time"]["hour"], saveInfo["time"]["minute"], saveInfo["time"]["second"]]
		nameLabel.visible = true
		roomLabel.visible = true
		dateLabel.visible = true
		timeLabel.visible = true

func _on_Button_pressed():
	selected.call_func(self.slot)
