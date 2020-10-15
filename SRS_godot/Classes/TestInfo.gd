extends WindowDialog


onready var TestName = get_node("Menu/TopVbox/TopHbox/TestName")
onready var TestProperties = get_node("Menu/Center/TestProperties/TestPropertyScroll/TestPointsProperty")
onready var StudentResults = get_node("Menu/Center/StudentResults/StudentsScroll/Students")
onready var MaxPoints = get_node("Menu/Center/TestProperties/MaxPoints")


func show_info():
	Log.debug("Test id %s in class %s info window loading" % [str(GlobalVars.activeTestId), str(GlobalVars.activeClass)])
	var data_dict = FileSys.student_data_load()
	var test_dict = data_dict.get(GlobalVars.activeClass).get("tests").get(str(GlobalVars.activeTestId))

	TestName.set_text(test_dict.test_name)
	print_student_results(data_dict)
	print_test_properties(test_dict)
	Log.debug("Test id %s in class %s info window loading" % [str(GlobalVars.activeTestId), str(GlobalVars.activeClass)])


func print_student_results(data_dict):

	for child in StudentResults.get_children():
		child.queue_free()

	var students_dict = data_dict.get(GlobalVars.activeClass).students
	var test_dict = data_dict.get(GlobalVars.activeClass).get("tests").get(str(GlobalVars.activeTestId))


	# Create lists and dicts for sorting
	var active_students = []
	var active_id_num = {}
	var inactive_students = []
	var inactive_id_num = {}

	for key in students_dict.keys():
		
		var student = students_dict[key]
		var student_test_info = student.get("tests").get(str(GlobalVars.activeTestId))
		
		# Set firts or last name sorting bases on add data variable
		var sort_name = student.last_name
		if FileSys.app_data_load().sort_students_by == "first_name":
			sort_name = student.first_name

		# collect grade limit info
		var test_grade_limits = {}
		test_grade_limits.E = test_dict.get("grade_limits").get("E")
		test_grade_limits.D = test_dict.get("grade_limits").get("D")
		test_grade_limits.C = test_dict.get("grade_limits").get("C")
		test_grade_limits.B = test_dict.get("grade_limits").get("B")
		test_grade_limits.A = test_dict.get("grade_limits").get("A")

		# calculate percent correct on test
		var points_correct = student_test_info.result[0]+student_test_info.result[1]+student_test_info.result[2]
		var points_max = test_dict.max_points[0]+test_dict.max_points[1]+test_dict.max_points[2]
		
		var percent = 0
		if points_max != 0:
			percent = stepify(float(points_correct) / float(points_max) * 100, 0.1)
		var percent_string = str(percent) + " %"
	
	
		var grade = AuxFunc.calculate_grade(student_test_info.result, test_grade_limits, student_test_info.completed)

		# Instance text scene
		var scene = load("res://InfoTexts/TestInfoStudentResult.tscn")
		var student_result = scene.instance()
		student_result.key_name = str(key)

		student_result.get_node("NameScroll/NameHbox/LabelName").set_text(student.first_name + " " + student.last_name)
		student_result.get_node("Done").pressed = student_test_info.completed
		student_result.get_node("LineEditE").set_text(str(student_test_info.result[0]))
		student_result.get_node("LineEditC").set_text(str(student_test_info.result[1]))
		student_result.get_node("LineEditA").set_text(str(student_test_info.result[2]))
		student_result.get_node("Percent").set_text(percent_string)
		student_result.get_node("Grade").set_text(grade)
		
		# Put active and inactive students in different lists and give the text different colors
		if student.active:
			student_result.get_node("NameScroll/NameHbox/LabelName").add_color_override("font_color", VisualVars.ColorWhite)
			active_students.append(student_result)
			active_id_num[sort_name] = student_result.key_name # This dict is used for sorting
		else:
			student_result.get_node("NameScroll/NameHbox/LabelName").add_color_override("font_color", VisualVars.ColorTextAlt)
			inactive_students.append(student_result)
			inactive_id_num[sort_name] = student_result.key_name # This dict is used for sorting
		Log.debug("Test result from student named " + student.first_name + student.last_name + " loaded")


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
	Log.debug("All student test results loaded, sorted by " + FileSys.app_data_load().sort_students_by + "and printed")

func print_test_properties(test_dict):

	for child in TestProperties.get_children():
		child.queue_free()
	
	# Create max points property
	var max_points_text = "Max Points"
	var max_points_E = str(test_dict.get("max_points")[0])
	var max_points_C = str(test_dict.get("max_points")[1])
	var max_points_A = str(test_dict.get("max_points")[2])

	MaxPoints.get_node("Label").set_text(max_points_text)
	MaxPoints.get_node("LineEditE").set_text(max_points_E)
	MaxPoints.get_node("LineEditC").set_text(max_points_C)
	MaxPoints.get_node("LineEditA").set_text(max_points_A)

	# Print grade limits
	var grade_limits = test_dict.get("grade_limits")
	for key in grade_limits.keys():
		var limit = grade_limits[key]
		var points_E = str(limit[0])
		var points_C = str(limit[1])
		var points_A = str(limit[2])
		var label_text = key + "-limit:"

		var scene = load("res://InfoTexts/TestProperty.tscn")
		var property = scene.instance()
		property.name = key

		property.get_node("Label").set_text(label_text)
		property.get_node("LineEditE").set_text(points_E)
		property.get_node("LineEditC").set_text(points_C)
		property.get_node("LineEditA").set_text(points_A)

		TestProperties.add_child(property)
	Log.debug("Test id %s properties printed" % GlobalVars.activeTestId)


func _on_Save_pressed():
	Log.debug("Save process for test %s in class %s initiated" % [str(GlobalVars.activeTestId), GlobalVars.activeClass])
	var data_dict = FileSys.student_data_load()
	var test_dict = data_dict.get(GlobalVars.activeClass).get("tests").get(str(GlobalVars.activeTestId))
	var students_dict = data_dict.get(GlobalVars.activeClass).get("students")

	test_dict = SaveFunc.save_test_info_name(test_dict, TestName)
	test_dict = SaveFunc.save_test_info_max_points(test_dict, MaxPoints)
	test_dict = SaveFunc.save_test_info_grade_limits(test_dict, TestProperties)
	
	students_dict = SaveFunc.save_students_test_name(students_dict, TestName)
	students_dict = SaveFunc.save_students_test_complete(students_dict, StudentResults)
	students_dict = SaveFunc.save_students_test_results(students_dict, StudentResults)
	Log.debug("Data collected from UI")

	# update data_dict and save the updated json
	data_dict.get(GlobalVars.activeClass).get("tests")[str(GlobalVars.activeTestId)] = test_dict
	data_dict.get(GlobalVars.activeClass)["students"] = students_dict
	
	# Update student result list and save data dictionary to file
	FileSys.student_data_save(data_dict)

	print_student_results(data_dict)
	get_parent().create_test_buttons()
	Log.info("Save process for test %s in class %s completed" % [str(GlobalVars.activeTestId), GlobalVars.activeClass])


func _on_Exit_pressed():
	hide()
	Log.debug("Back button pressed")


func _on_Remove_pressed():
	$RemoveConfirm.popup_centered()


func _on_RemoveConfirm_confirmed():
	Log.debug("Remove process for test %s in class %s initiated" % [str(GlobalVars.activeTestId), GlobalVars.activeClass])
	var data_dict = FileSys.student_data_load()
	var students_dict = data_dict.get(GlobalVars.activeClass).get("students")
	
	# Erase test for tests
	data_dict.get(GlobalVars.activeClass).tests.erase(str(GlobalVars.activeTestId))
	
	# Erase test from students
	for student_key in students_dict.keys():
		data_dict.get(GlobalVars.activeClass).get("students").get(student_key).get("tests").erase(str(GlobalVars.activeTestId))

	FileSys.student_data_save(data_dict)
	get_parent().create_test_buttons()
	hide()
	Log.info("Test %s removed from class %s" % [str(GlobalVars.activeTestId), GlobalVars.activeClass])


func _on_TestName_text_changed(text_input):
	var text_corrected = AuxFunc.remove_invalid_characters_from_text(text_input)
	if text_input != text_corrected:
		Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])
		$Menu/TopVbox/TopHbox/TestName.set_text(text_corrected)