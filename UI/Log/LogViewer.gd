extends PanelContainer

var messagePrefab = preload("res://UI/Log/MessageContainer.tscn")
var messages = []
var timeElapsed = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show() -> void:
    for message in Log.LOGS:
        var newMessage = messagePrefab.instance()
        newMessage.init(message["author"], message["message"])
        messages.push_back(newMessage)
        $"%LogsVBox".add_child(newMessage)
    visible = true
    timeElapsed = 0

func refreshMessages() -> void:
    ## TODO
    ## This is terrible, why are we deleting everything all the time
    if visible && Log.refreshNeeded:
        for message in messages:
            message.queue_free()
        messages.clear()
        for message in Log.LOGS:
            var newMessage = messagePrefab.instance()
            newMessage.init(message["author"], message["message"])
            messages.push_back(newMessage)
            $"%LogsVBox".add_child(newMessage)

func hide() -> void:
    for message in messages:
        message.queue_free()
    messages.clear()
    visible = false

func _on_CloseBtn_pressed():
    visible = false


func _process(delta):
    ## TODO
    ## Possible performance improvement
    ## don't loop all the time just directly
    ## call refresh when something is added
    ## to the log
    if visible:
        timeElapsed += delta
        if timeElapsed > 0.5:
            refreshMessages()