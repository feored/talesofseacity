extends PanelContainer

var timeElapsed = 0
onready var tween = create_tween()


func _ready():
	tween.stop()
	hide()


func hide() -> void:
	visible = false


func startFade() -> void:
	if self.is_inside_tree():
		if tween.is_valid():
			tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(self, "modulate", Color.transparent, 2.5)
		tween.tween_callback(self, "hide")


func setNewRoom(text: String):
	$"%RoomNameLabel".text = text
	modulate = Color(1, 1, 1, 1)
	timeElapsed = 0
	visible = true
	startFade()
