extends Control


func _ready():
	$Menu/CenterRow/ScrollContainer/Buttons/NewGameButton.grab_focus()


func _process(_delta):
	pass


func _on_SelectData_pressed():
	$LoadDataPopup.popup_centered()