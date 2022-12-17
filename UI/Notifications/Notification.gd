extends PanelContainer
const NOTIF_STATIC = 2.5
const NOTIF_TIMER = 1

var timeElapsed = 0
var fading = false

func _ready():
	pass

func startFade() -> void:
	fading = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.transparent, NOTIF_TIMER)
	tween.tween_callback(self, "queue_free")


func init(text: String):
	$Label.bbcode_text = text


func _process(delta):
	if !fading:
		timeElapsed += delta
		if timeElapsed > NOTIF_STATIC:
			startFade()
