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
	var active_students = []
	var inactive_students = []
	for id_num in students_dict:
		var scene = load("res://Buttons/StudentButton.tscn")
		var student_button = scene.instance()

		var student = students_dict.get(id_num)
		
		var first_name = student.first_name
		var last_name = student.last_name

		if not first_name:
			first_name = "First Name"
		if not last_name:
			last_name = "Last Name"

		student_button.get_node("Label").set_text(first_name + " " + last_name)
		student_button.name = str(id_num)
		student_button.student_id = int(id_num)
		
		# Put active and inactive students in different lists
		if student.active:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.StudentButtonColorActive)
			active_students.append(student_button)
		else:
			student_button.get_node("Label").add_color_override("font_color", VisualVars.StudentButtonColorInactive)
			inactive_students.append(student_button)
	
	var active_students_sorted = AuxFunc.sort_students_by_name(active_students)
	var inactive_students_sorted = AuxFunc.sort_students_by_name(inactive_students)

	# Put students as childs of Students node
	for active_student in active_students_sorted:
		Students.add_child(active_student)
	for inactive_student in inactive_students_sorted:
		Students.add_child(inactive_student)


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
