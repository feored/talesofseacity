extends RichTextLabel

var choiceId : int

## funcref

var baseText = ""

const availableColor : String = "42c5f5"
const hoverColor : String = "ff0000"

var choicePickedCallback : Object

func colorText(text: String, color : String):
    return "[color=#%s]%s[/color]" % [color, text]

func setChoice(text : String, id : int) -> void:
	self.baseText = text
	self.bbcode_text = colorText(baseText, availableColor)
	self.choiceId = id


func _on_DialogueChoice_gui_input(event:InputEvent):
	## choice picked
	##print(event)
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		choicePickedCallback.call_func(self.choiceId)
		queue_free()


func _on_DialogueChoice_mouse_entered():
	self.bbcode_text = colorText(baseText, hoverColor)


func _on_DialogueChoice_mouse_exited():
	self.bbcode_text = colorText(baseText, availableColor)
