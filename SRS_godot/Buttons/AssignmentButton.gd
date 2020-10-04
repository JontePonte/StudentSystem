extends Button


onready var RootScene = get_tree().get_root().get_node("ClassScene")


var assignment_id = 0


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	GlobalVars.activeAssignmentId = assignment_id
	
	RootScene.get_node("AssignmentInfo").popup_centered()
	RootScene.get_node("AssignmentInfo").show_info()
	Log.debug("Assignment id %s pressed, popup window loaded" % assignment_id)
