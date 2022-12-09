extends RichTextLabel

var choiceId : int

## funcref

var baseText = ""

var choicePickedCallback : Object


func setChoice(text : String, id : int) -> void:
	self.baseText = text
	self.bbcode_text = text
	self.choiceId = id

func _on_DialogueChoice_gui_input(event:InputEvent):
	## choice picked
	##print(event)
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		choicePickedCallback.call_func(self.choiceId)
		queue_free()


func _on_DialogueChoice_mouse_entered():
	self.bbcode_text = "[color=#ff0000]%s[/color]" % baseText


func _on_DialogueChoice_mouse_exited():
	self.bbcode_text = baseText
