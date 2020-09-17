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
	var _is_change_ok = get_tree().change_scene(path)
