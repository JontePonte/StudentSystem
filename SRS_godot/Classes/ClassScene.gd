extends Control


func _ready():
	var active_class = GlobalVars.activeClass
	$Menu/Header.set_text(active_class)
