extends RichTextLabel


var elapsedTime : float = 0
var over = false

## funcref

var lineOverCallback : Object
var lineCompleteCallback : Object


func setComplete() -> void:
    set_visible_characters(-1)
    lineCompleteCallback.call_func()
    over = true

func next() -> void:
    if !over:
        setComplete()
    elif over:
        lineOverCallback.call_func()
        queue_free()
        
func setText(text: String) -> void:
    self.bbcode_text = text
    self.set_visible_characters(0)

func _process(delta):
    if !over:
        elapsedTime += delta
        self.set_visible_characters(int(elapsedTime*30))
        if self.visible_characters >= self.get_total_character_count():
            setComplete()
