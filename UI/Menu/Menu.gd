extends Control

const SAVEPATH = "user://saves/"

var audioMenuPrefab = preload("res://UI/Menu/AudioMenu/AudioMenu.tscn")

## funcrefs
onready var main = $"/root/Main"

var menuChildren = []


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# func takeScreenshot() -> void:
#     var screenshot = get_viewport().get_texture().get_data()
#     screenshot.flip_y()
#     screenshot.save_png("user://%s.png" % OS.get_unix_time())


# func _on_ScreenshotBtn_pressed():
#     var UINode = get_node("%UI")
#     UINode.scale = Vector2(0, 0)
#     takeScreenshot()
#     UINode.scale = Vector2(1, 1)

func openAudioMenu() -> void:
    var audioMenu = audioMenuPrefab.instance()
    audioMenu.remove = funcref(self, "quitMenu")
    add_child(audioMenu)
    menuChildren.push_back(audioMenu)

func hide():
    #visible = false
    queue_free()

func _on_ContinueBtn_pressed():
    hide()


func commitSave(saveVar : Dictionary, saveFilePath : String):
    var directory = Directory.new();
    if (!directory.dir_exists(SAVEPATH)):
        var err = directory.make_dir(SAVEPATH)
        if err != OK:
            print("Failed to create /saves/ directory to save games into.")
            return
    var file = File.new()
    file.open(saveFilePath, File.WRITE)
    file.store_var(saveVar)
    file.close()


func save():
    var saveFilePath = "%s%s.save" % [SAVEPATH, "savetest"]# OS.get_unix_time()]
    var newSave = {}
    newSave["State"] = State.save()
    newSave["Quests"] = Quests.save()
    newSave["Items"] = Items.save()
    newSave["Main"] = main.save()
    newSave["NPCs"] = NPCs.save()

    commitSave(newSave, saveFilePath)
    hide()


func loadGame():
    loadSave("%s%s.save" % [SAVEPATH, "savetest"])
    hide()


func loadSave(savePath : String):
    print("Loading save %s" % savePath)

    var directory = Directory.new();
    if (!directory.dir_exists(SAVEPATH) || !directory.file_exists(savePath)):
        print("Failed to find the save game %s that needs to be loaded." % savePath)
        return

    var file = File.new()
    file.open(savePath, File.READ)
    var save = file.get_var()

    ## Load State
    State.load(save["State"])
    Quests.load(save["Quests"])
    Items.load(save["Items"])
    main.load(save["Main"])
    NPCs.load(save["NPCs"])

    file.close()
    
func _input(event):
    if event.is_action_pressed("menu"):
        quitMenu()

func quitMenu():
    if menuChildren.size() == 0:
        queue_free()
    else:
        menuChildren.pop_back().queue_free()

func _on_SaveBtn_pressed():
    save()


func _on_LoadBtn_pressed():
    loadGame()


func _on_AudioBtn_pressed():
    openAudioMenu()
