extends RichTextLabel


var elapsedTime : float = 0
var elapsedText : int = 0
var over = false

## funcref

var lineCompleteCallback : Object


func setComplete() -> void:
	set_visible_characters(-1)
	over = true

func next() -> void:
	if !over:
		setComplete()
	elif over:
		lineCompleteCallback.call_func()
		
func clear() -> void:
	self.over = false
	self.bbcode_text = ""
	self.elapsedTime = 0
	self.elapsedText = 0
	self.set_visible_characters(0)

func addText(newText: String) -> void:
	self.over = false
	self.elapsedText = self.text.length()
	self.elapsedTime = 0
	self.bbcode_text = self.bbcode_text + "\n" + newText
	self.set_visible_characters(elapsedText)

func _process(delta):
	if !over:
		elapsedTime += delta
		self.set_visible_characters(self.elapsedText + int(elapsedTime*30))
		if self.visible_characters >= self.get_total_character_count():
			setComplete()
