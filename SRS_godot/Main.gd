extends Control


var ActiveDataFile = ""


func _ready():
	$Menu/CenterRow/ScrollContainer/Buttons/NewGameButton.grab_focus()
	ActiveDataFile = GlobalVars.ActiveDataFile


func _process(_delta):
	pass
