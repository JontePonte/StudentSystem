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
	# Create lists and dicts for sorting
	var active_students = []
	var active_id_num = {}
	var inactive_students = []
	var inactive_id_num = {}

	for id_num in students_dict:
		var scene = load("res://Buttons/StudentButton.tscn")
		var student_button = scene.instance()

		var student = students_dict.get(id_num)
		
		var first_name = student.first_name
		var last_name = student.last_name

		# Let the botton say "Fisrt Name Last Name" if no name is given
		if not first_name:
			first_name = "First Name"
		if not last_name:
			last_name = "Last Name"

		student_button.get_node("Label").set_text(first_name + " " + last_name)
		student_button.name = str(id_num)
		student_button.student_id = int(id_num)

		# Sort students by first or last name based on info in app_data
		var sort_name = last_name
		if FileSys.app_data_load().sort_students_by == "first_name":
			sort_name = first_name
		
		# Put active and inactive students in different lists and give the text different colors
		if student.active:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.ColorText)
			active_students.append(student_button)
			active_id_num[sort_name] = student_button.student_id # This dict is used for sorting
		else:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.ColorTextAlt)
			inactive_students.append(student_button)
			inactive_id_num[last_name] = student_button.student_id # This dict is used for sorting
	
	# Collect arrays of sorted keys
	var active_keys_sorted = AuxFunc.sort_students_by_name(active_id_num)
	var inactive_keys_sorted = AuxFunc.sort_students_by_name(inactive_id_num)

	# Put student buttons as childs of Students node
	for key in active_keys_sorted:
		for button in active_students:		# not pretty but works...
			if button.student_id == key:
				Students.add_child(button)
	for key in inactive_keys_sorted:
		for button in inactive_students:
			if button.student_id == key:
				Students.add_child(button)


func _on_BackButton_pressed():
	var path = "res://Main.tscn"
	var _is_main = get_tree().change_scene(path)


func _on_AddStudent_pressed():
	var data_dict = FileSys.student_data_load()
	var students_dict = data_dict.get(GlobalVars.activeClass).students

	var tests = AuxFunc.create_unfinished_tests(data_dict)
	var assignments = AuxFunc.create_unfinished_assignments(data_dict)

	var new_studnet = {
		"active": true,
		"class": GlobalVars.activeClass,
		"comments": {},
		"email": "",
		"first_name": "",
		"last_name": "",
		"pers_nr": 0,
		"assignments": assignments,
		"tests": tests
		}

	var new_student_key = AuxFunc.create_new_key_number(students_dict)

	# add student to student data dictionary
	data_dict.get(GlobalVars.activeClass).students[new_student_key] = new_studnet
	FileSys.student_data_save(data_dict)

	# Show popup window with the the new student
	GlobalVars.activeStudentId = int(new_student_key)
	$StudentInfo.popup_centered()
	$StudentInfo.show_info()
	create_student_buttons()
