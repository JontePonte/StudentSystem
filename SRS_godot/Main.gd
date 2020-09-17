extends Control


var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()



func _ready():  
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	create_subject_buttons()


func create_subject_buttons(): 
	var s_data = FileSys.student_data_load()
	print(s_data.keys())

	for subject in s_data.keys():
		var scene = load("res://Buttons/MenuButton.tscn")
		var subject_button = scene.instance()

		subject_button.get_node("Label").set_text(subject)

		$Menu/CenterRow/ScrollSubjects/Subjects.add_child(subject_button)

	# Make the first button selected so the menu can be navigated with arrows
	# $Menu/CenterRow/ScrollContainer/Buttons/NewGameButton.grab_focus()


func _on_SelectData_pressed():
	$LoadDataPopup.popup_centered()


func _on_LoadDataPopup_file_selected(path):
	FileSys.change_active_data_file(path)
	$Menu/HBoxContainer/LoadDataCont/SelectData.update_text()
