extends Button


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if pressed:
		button_pressed()


func button_pressed():
	get_parent().get_parent().get_parent().get_parent().get_parent().go_to_class()
