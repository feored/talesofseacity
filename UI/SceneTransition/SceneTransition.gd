extends CanvasLayer

var menuPrefab = preload("res://UI/Menu/Menu.tscn")

var currentGame : Object
var currentMenu : Object




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func changeScene(targetScene: String)-> void:
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(targetScene)
	$AnimationPlayer.play_backwards()


func gameToMenu():
	   $AnimationPlayer.play("dissolve")
	   yield($AnimationPlayer, "animation_finished")
	   currentGame = get_tree().root.get_node("Main")
	   get_tree().root.remove_child(currentGame)
	   currentMenu = menuPrefab.instance()
	   currentMenu.main = currentGame
	   get_tree().root.add_child(currentMenu)
	   $AnimationPlayer.play_backwards()

func menuToGame():
	   $AnimationPlayer.play("dissolve")
	   yield($AnimationPlayer, "animation_finished")
	   currentMenu.queue_free()
	   get_tree().root.add_child(currentGame)
	   $AnimationPlayer.play_backwards()
