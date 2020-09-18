extends Button


onready var RootScene = get_tree().get_root().get_node("ClassScene")


var student_id = 0


func _ready():
	pass


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	GlobalVars.activeStudentId = student_id
	
	RootScene.get_node("StudentInfo").popup_centered()
	RootScene.get_node("StudentInfo").show_info()
