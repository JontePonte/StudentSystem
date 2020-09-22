extends Control


onready var Students = get_node("Menu/RowsCont/StundetsCont/StudentsScroll/Students")


func _ready():
	# Set header name
	var active_class = GlobalVars.activeClass
	$Menu/Header.set_text(active_class)

	create_student_buttons()


func create_student_buttons(): 
	var student_data = FileSys.student_data_load()
	var students_dict = student_data.get(GlobalVars.activeClass).students

	# Remove all previous student buttons
	for child in Students.get_children():
		child.queue_free()

	# Instance menu buttons and make them childs of scroll menu
	for id_num in students_dict:
		var scene = load("res://Buttons/StudentButton.tscn")
		var student_button = scene.instance()

		var student = students_dict.get(id_num)

		student_button.get_node("Label").set_text(student.first_name + " " + student.last_name)
		student_button.name = str(id_num)
		student_button.student_id = int(id_num)
		if student.active:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.StudentButtonColorActive)
		else:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.StudentButtonColorInactive)

		Students.add_child(student_button)


func _on_BackButton_pressed():
	var path = "res://Main.tscn"
	var _is_main = get_tree().change_scene(path)


func _on_AddStudent_pressed():

	var new_studnet = {
		"active": true,
		"class": GlobalVars.activeClass,
		"comments": {},
		"email": "",
		"first_name": "First name",
		"last_name": "Last Name",
		"pers_nr": 0,
		"assignments": {},
		"tests": {}
		}

	var data_dict = FileSys.student_data_load()
	var students_dict = data_dict.get(GlobalVars.activeClass).students

	var new_student_key = AuxFunc.create_new_key_number(students_dict)

	# add student to student data dictionary
	data_dict.get(GlobalVars.activeClass).students[new_student_key] = new_studnet
	FileSys.student_data_save(data_dict)

	# Show popup window with the the new student
	GlobalVars.activeStudentId = int(new_student_key)
	$StudentInfo.popup_centered()
	$StudentInfo.show_info()
	create_student_buttons()
