extends PanelContainer

var journalEntryPrefab = preload("res://UI/Journal/JournalEntry.tscn")



func hide() -> void:
	visible = false

func addJournalEntry(questTitle: String, questEntries : Array) -> void:
	var newJournalEntry = journalEntryPrefab.instance()
	newJournalEntry.setEntryData(questTitle, questEntries)
	$"%Quests".add_child(newJournalEntry)

func show() -> void:
	if Quests.journalRefreshNeeded:
		for quest in $"%Quests".get_children():
			quest.queue_free()
		for questName in Quests.JOURNAL:
			addJournalEntry(questName, Quests.JOURNAL[questName])
	visible = true

func _on_CloseBtn_pressed():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
