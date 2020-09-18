extends WindowDialog


func show_info():
	var student_dict = collect_info()

	# set popup menu header to student name
	$Menu/StudentName.set_text(student_dict.first_name + " " + student_dict.last_name)

	print_student_info(student_dict)
	print_test_info(student_dict)


func collect_info():
	# Load students in the class into student_list
	var students_data = FileSys.student_data_load()
	var students_list = students_data.get(GlobalVars.activeClass).students
	
	# Collect student info in student_dict
	for student in students_list:
		if student.id_num == GlobalVars.activeStudentId:
			return student


func print_student_info(student_dict):
	# Clear any old info
	for child in $Menu/InfoHBox/InfoKeys.get_children():
		child.queue_free()
	for child in $Menu/InfoHBox/InfoVariables.get_children():
		child.queue_free()

	# Print class, email and personal number
	for info_key in ["Class", "Email", "Pers Nr"]:
		var scene = load("res://InfoTexts/StudentInfoText.tscn")
		var info_text = scene.instance()

		info_text.get_node("Label").set_text(info_key)
		$Menu/InfoHBox/InfoKeys.add_child(info_text)
	
	# Collect info to print right of class, email and personal number
	var info_variable_list = [
		str(student_dict.get("class")),
		str(student_dict.get("email")),
		str(student_dict.get("pers_nr"))]

	# print the info
	for info_var in info_variable_list:
		var scene = load("res://InfoTexts/StudentInfoText.tscn")
		var info_text = scene.instance()

		info_text.get_node("Label").set_text(info_var)
		$Menu/InfoHBox/InfoVariables.add_child(info_text)
	

func print_test_info(student_dict):
	# Clear old tests in pop up box
	for child in $Menu/TestsCont/TestsScroll/Tests.get_children():
		child.queue_free()

	var tests_list = student_dict.get("tests")
	
	for test in tests_list:
		var scene = load("res://InfoTexts/TestInfoText.tscn")
		var test_text_row = scene.instance()
		
		# Extract max points from data file
		var max_points = []
		var data_dict = FileSys.student_data_load()
		for test_base in data_dict.get(GlobalVars.activeClass).get("tests"):
			if test.test_name == test_base.test_name:
				max_points = test_base.get("max_points")
		
		var percents = calculate_percents(test.result, max_points)
		
		# Add all texts to text_text row
		test_text_row.get_node("Name").set_text(test.test_name)
		test_text_row.get_node("Max").set_text(str(max_points))
		test_text_row.get_node("Result").set_text(str(test.result))
		test_text_row.get_node("Percent").set_text(percents)
		test_text_row.get_node("Grade").set_text(test.grade)

		$Menu/TestsCont/TestsScroll/Tests.add_child(test_text_row)

func calculate_percents(res_points, max_points):
	var e = stepify((res_points[0] / max_points[0]) * 100, 0.01)
	var c = stepify((res_points[1] / max_points[1]) * 100, 0.01)
	var a = stepify((res_points[2] / max_points[2]) * 100, 0.01)
	
	var e_string = str(e) + "% "
	var c_string = str(c) + "% "
	var a_string = str(a) + "% "

	return e_string + c_string + a_string


