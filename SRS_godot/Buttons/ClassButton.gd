extends Button


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	# Set active class to the buttons name so the class scene knows
	GlobalVars.activeClass = self.name

	var path = "res://Classes/ClassScene.tscn"
	var _is_class_scene = get_tree().change_scene(path)
	Log.debug("Class pressed, scene changed to " + path)
