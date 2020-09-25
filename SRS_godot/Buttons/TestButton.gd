extends Button


onready var RootScene = get_tree().get_root().get_node("ClassScene")


var test_id = 0


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	GlobalVars.activeTestId = test_id
	
	RootScene.get_node("TestInfo").popup_centered()
	RootScene.get_node("TestInfo").show_info()
