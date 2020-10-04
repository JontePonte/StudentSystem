extends Control


onready var VersionLabel = get_node("Menu/HBoxContainer/VersionLabel")


var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()



func _ready():
	Log.info("Main window initiated, main menu loading")
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

	VisualVars.set_color_palette()
	
	create_classes_buttons()
	VersionLabel.set_text("Version: " + str(GlobalVars.version))
	Log.debug("Main menu loaded")


func create_classes_buttons():
	# Clear any old buttons
	for child in $Menu/CenterRow/ScrollClass/Classes.get_children():
		child.queue_free()
	
	var s_data = FileSys.student_data_load()

	# Instance menu buttons and make them childs of scroll menu
	for subject in s_data.keys():
		var scene = load("res://Buttons/ClassButton.tscn")
		var class_button = scene.instance()

		class_button.get_node("Label").set_text(subject)
		class_button.name = subject

		$Menu/CenterRow/ScrollClass/Classes.add_child(class_button)
	
	# Make the first button selected so the menu can be navigated with arrows
	$Menu/CenterRow/ScrollClass/Classes.get_node(s_data.keys()[0]).grab_focus()
	Log.debug("Class buttons added to main scene")


func _on_SelectData_pressed():
	$LoadDataPopup.popup_centered()


func _on_LoadDataPopup_file_selected(path):
	FileSys.change_active_data_file(path)
	$Menu/HBoxContainer/LoadDataCont/SelectData.update_text()
	create_classes_buttons()
	Log.info("New data file selected")
	Log.debug("New data file path: " + path)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Log.close_log_file()
		get_tree().quit() # default behavior
