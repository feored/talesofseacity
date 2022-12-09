extends RichTextLabel

const DEFAULT_DELAY = 2

var elapsedTime : float = 0
var timeToNext : float
var shouldHang : bool = false

## funcref

var lineOverCallback : Object


func setText(text: String, delay : float = DEFAULT_DELAY) -> void:
	self.bbcode_text = text
	self.set_visible_characters(0)
	self.timeToNext = delay

func _process(delta):
	elapsedTime += delta
	if shouldHang:
		timeToNext -= delta
		if timeToNext <= 0:
			lineOverCallback.call_func()
			queue_free()
	else :
		self.set_visible_characters(int(elapsedTime*50))
		if self.visible_characters >= self.get_total_character_count():
			shouldHang = true
