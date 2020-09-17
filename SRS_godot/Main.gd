extends Control


var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()


func _ready():
  
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	$Menu/CenterRow/ScrollContainer/Buttons/NewGameButton.grab_focus()


func _process(_delta):
	pass


func _on_SelectData_pressed():
	$LoadDataPopup.popup_centered()


func _on_LoadDataPopup_file_selected(path):
	FileSys.change_active_data_file(path)
	$Menu/HBoxContainer/LoadDataCont/SelectData.update_text()
