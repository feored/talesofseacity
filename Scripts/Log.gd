extends Node

const MAX_LOGS = 50
var refreshNeeded = false
var LOGS = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func addLog(author : String, message : String) -> void:
    LOGS.push_back(
        {
            "author" : author,
            "message" : message
        }
    )

    if LOGS.size() > MAX_LOGS:
        LOGS.pop_front()
    refreshNeeded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
