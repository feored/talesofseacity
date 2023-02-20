extends CanvasLayer

var menuPrefab = preload("res://UI/Menu/Menu.tscn")
var gamePrefab = preload("res://Main.tscn")

var currentGame : Object
var currentNode : Object



# Called when the node enters the scene tree for the first time.
func _ready():
	currentGame = gamePrefab.instance()
	


func changeScene(targetScene: String)-> void:
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(targetScene)
	$AnimationPlayer.play_backwards()

func xToY(xNode, yNode):
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	if xNode == currentGame:
		get_tree().root.remove_child(currentGame)
	else:
		xNode.queue_free()
	get_tree().root.add_child(yNode)
	$AnimationPlayer.play_backwards()

func xToYScene(xNode, yScene):
	var yNode = load(yScene).instance()
	xToY(xNode, yNode)

	
