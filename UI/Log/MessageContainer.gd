extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(author : String, message : String) -> void:
    if author != "":
        author += " :"
    $"%Author".text = author
    $"%Message".bbcode_text = message        