extends Button


onready var RootScene = get_tree().get_root().get_node("ClassScene")


func _ready():
	pass


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	RootScene.get_node("StudentInfo").popup_centered()