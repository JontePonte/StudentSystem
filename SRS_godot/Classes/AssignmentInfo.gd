extends WindowDialog


onready var AssignmentName = get_node("Menu/TopVbox/TopHbox/AssignmentName")
onready var StudentResults = get_node("Menu/Center/StudentResults/StudentsScroll/Students")
onready var DescriptionTextEdit = get_node("Menu/Center/AssignmentDescription/AssignmentDescriptionScroll/AssignmentDescription/TextEdit")


func show_info():
	Log.debug("Assignment %s in class %s window loading" % [str(GlobalVars.activeAssignmentId), str(GlobalVars.activeClass)])
	var data_dict = FileSys.student_data_load()
	var assignment_dict = data_dict.get(GlobalVars.activeClass).get("assignments").get(str(GlobalVars.activeAssignmentId))

	AssignmentName.set_text(assignment_dict.assignment_name)
	print_student_results(data_dict)
	print_assignment_description(assignment_dict)
	Log.info("Assignment %s in %s window opened" % [str(GlobalVars.activeAssignmentId), str(GlobalVars.activeClass)])


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
		Log.debug("Assignment result from student named " + student.first_name + student.last_name + " loaded")

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
	Log.debug("All student assignment results loaded, sorted by " + FileSys.app_data_load().sort_students_by + "and printed")


func print_assignment_description(assignment_dict):
	var description = assignment_dict.description
	DescriptionTextEdit.text = description
	Log.debug("Assignment description loaded")


func _on_AssignmentName_text_changed(text_input):
    var text_corrected = AuxFunc.remove_invalid_characters_from_text(text_input)
    if text_input != text_corrected:
        Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])
        $Menu/TopVbox/TopHbox/AssignmentName.set_text(text_corrected)


func _on_TextEdit_text_changed():
	# TextEdit signal does not include input text variable
	var text_input_field = $Menu/Center/AssignmentDescription/AssignmentDescriptionScroll/AssignmentDescription/TextEdit
	var text_input = text_input_field.get_text()
	
	var text_corrected = AuxFunc.remove_invalid_characters_from_text(text_input)
	if text_input != text_corrected:
		Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])
		print("p")
		$Menu/Center/AssignmentDescription/AssignmentDescriptionScroll/AssignmentDescription/TextEdit.set_text(text_corrected)


func _on_Save_pressed():
	Log.debug("Assignment save process started")
	var data_dict = FileSys.student_data_load()
	var assignment_dict = data_dict.get(GlobalVars.activeClass).get("assignments").get(str(GlobalVars.activeAssignmentId))
	var students_dict = data_dict.get(GlobalVars.activeClass).get("students")

	assignment_dict = SaveFunc.save_assignment_info_name(assignment_dict, AssignmentName)
	assignment_dict = SaveFunc.save_assignment_info_description(assignment_dict, DescriptionTextEdit)

	students_dict = SaveFunc.save_students_assignment_name(students_dict, AssignmentName)
	students_dict = SaveFunc.save_students_assignment_complete(students_dict, StudentResults)
	students_dict = SaveFunc.save_students_assignment_comment(students_dict, StudentResults)
	students_dict = SaveFunc.save_students_assignment_grade(students_dict, StudentResults)
	Log.debug("Assignment info finnished collecting from UI")

	# update data_dict and save the updated json
	data_dict.get(GlobalVars.activeClass).get("assignments")[str(GlobalVars.activeAssignmentId)] = assignment_dict
	data_dict.get(GlobalVars.activeClass)["students"] = students_dict

	# Update class assignment buttons  and save data dictionary to file
	FileSys.student_data_save(data_dict)
	get_parent().create_assignment_buttons()
	Log.info("Assignment id %s data saved to file" % str(GlobalVars.activeAssignmentId))


func _on_Exit_pressed():
	hide()
	Log.debug("Assignment exit button pressed")

	
func _on_Remove_pressed():
	$RemoveConfirm.popup_centered()


func _on_RemoveConfirm_confirmed():
	var data_dict = FileSys.student_data_load()
	var students_dict = data_dict.get(GlobalVars.activeClass).get("students")
	
	# Erase assignment from assignments
	data_dict.get(GlobalVars.activeClass).assignments.erase(str(GlobalVars.activeAssignmentId))
	
	# Erase assignments from students
	for student_key in students_dict.keys():
		data_dict.get(GlobalVars.activeClass).get("students").get(student_key).get("assignments").erase(str(GlobalVars.activeAssignmentId))

	FileSys.student_data_save(data_dict)
	get_parent().create_assignment_buttons()
	hide()
	Log.info("Assignment id %s removed from %s" % [str(GlobalVars.activeAssignmentId), str(GlobalVars.activeClass)])

