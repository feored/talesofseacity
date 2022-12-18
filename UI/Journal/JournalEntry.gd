extends PanelContainer

var questEntryPrefab = preload("res://UI/Journal/QuestEntry.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func setEntryData(questName : String, entries : Array) -> void:
    $"%QuestTitle".text = questName
    for entry in entries:
       var newQuestEntry = questEntryPrefab.instance()
       newQuestEntry.text = entry
       $"%QuestEntries".add_child(newQuestEntry) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_toggled(button_pressed:bool):
	$"%QuestEntries".visible = !button_pressed
