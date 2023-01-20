extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var panels : Array

var mainMenuPrefab = preload("res://UI/Menu/Menu.tscn")

onready var rulaPanel = $"%Rula"
onready var inventoryPanel = $"%Inventory"
onready var logPanel = $"%Log"
onready var journalPanel = $"%Journal"

# Called when the node enters the scene tree for the first time.
func _ready():
    set_process_input(true)
    
    panels = [
       rulaPanel,
       inventoryPanel,
       logPanel,
       journalPanel
    ]


func _input(event):
    if event.is_action_pressed("inventory"):
        _on_InventoryBtn_pressed()
    elif event.is_action_pressed("rula"):
        _on_RulaBtn_pressed()
    elif event.is_action_pressed("log"):
        _on_LogBtn_pressed()
    elif event.is_action_pressed("journal"):
        _on_JournalBtn_pressed()
    elif event.is_action_pressed("menu"):
        SceneTransition.gameToMenu()
    
func hideAllPanels():
    for panel in panels:
        panel.hide()

func showPanel(panel : Node) -> void:
    hideAllPanels()
    panel.show()

func _on_RulaBtn_pressed():
    showPanel(rulaPanel) if !rulaPanel.visible else rulaPanel.hide()

func _on_InventoryBtn_pressed():
    showPanel(inventoryPanel) if !inventoryPanel.visible else inventoryPanel.hide()

func _on_LogBtn_pressed():
    showPanel(logPanel) if !logPanel.visible else logPanel.hide()
    
func _on_JournalBtn_pressed():
    showPanel(journalPanel) if !journalPanel.visible else journalPanel.hide()
    

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
    get_node("/root/Main").doorChangeRoom(target)
    


func _process(delta):
    var blur = false
    for p in panels:
        if p.visible:
            blur = true
            break
    $"%blur".visible = blur
    if blur:
        get_tree().paused = true
    else:
        get_tree().paused = false

func _on_Button_pressed():
    _on_InventoryBtn_pressed()