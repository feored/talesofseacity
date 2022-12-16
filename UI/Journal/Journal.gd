extends PanelContainer

var journalEntryPrefab = preload("res://UI/Journal/JournalEntry.tscn")



func hide() -> void:
	visible = false

func showJournalEntry(entry : Dictionary) -> void:
	var newJournalEntry = journalEntryPrefab.instance()
	newJournalEntry.setEntryData(entry["title"], entry["entry"])
	$"%JournalEntries".add_child(newJournalEntry)
	$"%JournalEntries".move_child(newJournalEntry, 0)

func show() -> void:
	if Quests.journalRefreshNeeded:
		for entry in $"%JournalEntries".get_children():
			$"%JournalEntries".remove_child(entry)
			entry.queue_free()
		for entry in Quests.JOURNAL:
			showJournalEntry(entry)
	visible = true

func _on_CloseBtn_pressed():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
