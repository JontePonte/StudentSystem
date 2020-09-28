extends WindowDialog


onready var AssignmentName = get_node("Menu/TopVbox/TopHbox/AssignmentName")
onready var StudentResults = get_node("Menu/Center/StudentResults/StudentsScroll/Students")
onready var DescriptionTextEdit = get_node("Menu/Center/AssignmentDescription/AssignmentDescriptionScroll/AssignmentDescription/TextEdit")


func show_info():
	var data_dict = FileSys.student_data_load()
	var assignment_dict = data_dict.get(GlobalVars.activeClass).get("assignments").get(str(GlobalVars.activeAssignmentId))

	AssignmentName.set_text(assignment_dict.assignment_name)
	print_student_results(data_dict)
	print_assignment_description(assignment_dict)


func print_student_results(data_dict):
	# Remove all old student result info before printing new
	for child in StudentResults.get_children():
		child.queue_free()
	
	var students_dict = data_dict.get(GlobalVars.activeClass).students

	# Create lists and dicts for sorting
	var active_students = []
	var active_id_num = {}
	var inactive_students = []
	var inactive_id_num = {}

	for student_key in students_dict.keys():
		# Store student och and student assignemtn info
		var student = students_dict.get(student_key)
		var student_assignment_dict = student.get("assignments").get(str(GlobalVars.activeAssignmentId))

		# Set firts or last name sorting bases on add data variable
		var sort_name = student.last_name
		if FileSys.app_data_load().sort_students_by == "first_name":
			sort_name = student.first_name
		
			# Instance text scene
		var scene = load("res://InfoTexts/AssignmentInfoStudentResult.tscn")
		var student_result = scene.instance()

		student_result.key_name = str(student_key)
		student_result.get_node("NameScroll/NameHbox/LabelName").set_text(student.first_name + " " + student.last_name)
		student_result.get_node("Done").pressed = student_assignment_dict.completed
		student_result.get_node("Comment").set_text(student_assignment_dict.comment)
		student_result.get_node("Grade").set_text(student_assignment_dict.grade)

		# Put active and inactive students in different lists and give the text different colors
		if student.active:
			student_result.get_node("NameScroll/NameHbox/LabelName").add_color_override("font_color", VisualVars.ColorWhite)
			active_students.append(student_result)
			active_id_num[sort_name] = student_result.key_name # This dict is used for sorting
		else:
			student_result.get_node("NameScroll/NameHbox/LabelName").add_color_override("font_color", VisualVars.ColorTextAlt)
			inactive_students.append(student_result)
			inactive_id_num[sort_name] = student_result.key_name # This dict is used for sorting

	# Collect arrays of sorted keys
	var active_keys_sorted = AuxFunc.sort_students_by_name(active_id_num)
	var inactive_keys_sorted = AuxFunc.sort_students_by_name(inactive_id_num)

	# Put student buttons as childs of Students node
	for key in active_keys_sorted:
		for student_result in active_students:		# not pretty but works...
			if student_result.key_name == key:
				StudentResults.add_child(student_result)
	for key in inactive_keys_sorted:
		for student_result in inactive_students:
			if student_result.key_name == key:
				StudentResults.add_child(student_result)


func print_assignment_description(assignment_dict):
	var description = assignment_dict.description
	DescriptionTextEdit.text = description


func _on_Save_pressed():
	print("Save Assignment info")


func _on_Exit_pressed():
	hide()

	
func _on_Remove_pressed():
	$RemoveConfirm.popup_centered()


func _on_RemoveConfirm_confirmed():
	print("Remove Assignment")
