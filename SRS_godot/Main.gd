extends Control


var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()



func _ready():  
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	create_classes_buttons()


func create_classes_buttons(): 
	var s_data = FileSys.student_data_load()
	print(s_data.keys())

	# Instance menu buttons and make them childs of scroll menu
	for subject in s_data.keys():
		var scene = load("res://Buttons/ClassButton.tscn")
		var class_button = scene.instance()

		class_button.get_node("Label").set_text(subject)
		class_button.name = subject

		$Menu/CenterRow/ScrollClass/Classes.add_child(class_button)

	# Make the first button selected so the menu can be navigated with arrows
	$Menu/CenterRow/ScrollClass/Classes.get_node(s_data.keys()[0]).grab_focus()


func _on_SelectData_pressed():
	$LoadDataPopup.popup_centered()


func _on_LoadDataPopup_file_selected(path):
	FileSys.change_active_data_file(path)
	$Menu/HBoxContainer/LoadDataCont/SelectData.update_text()
