extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func changeScene(targetScene: String)-> void:
    $AnimationPlayer.play("dissolve")
    yield($AnimationPlayer, "animation_finished")
    get_tree().change_scene(targetScene)
    $AnimationPlayer.play_backwards()
