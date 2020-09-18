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
		var scene = load("res://InfoTexts/StudentInfoTextEdit.tscn")
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
		
		# Extract max points and grade limits from data file
		var max_points = []
		var grade_limits = {}
		var data_dict = FileSys.student_data_load()
		for test_base in data_dict.get(GlobalVars.activeClass).get("tests"):
			if test.test_name == test_base.test_name:
				max_points = test_base.get("max_points")
				grade_limits.E = test_base.get("grade_limits").get("E")
				grade_limits.D = test_base.get("grade_limits").get("D")
				grade_limits.C = test_base.get("grade_limits").get("C")
				grade_limits.B = test_base.get("grade_limits").get("B")
				grade_limits.A = test_base.get("grade_limits").get("A")
		
		
		var percents = calculate_percents(test.result, max_points)
		var grade = calculate_grade(test.result, grade_limits)
		
		# Add all texts to text_text row
		test_text_row.get_node("Name").set_text(test.test_name)

		test_text_row.get_node("Max/MaxE").set_text(str(max_points[0]))
		test_text_row.get_node("Max/MaxC").set_text(str(max_points[1]))
		test_text_row.get_node("Max/MaxA").set_text(str(max_points[2]))
		
		test_text_row.get_node("Result/ResultE").set_text(str(test.result[0]))
		test_text_row.get_node("Result/ResultC").set_text(str(test.result[1]))
		test_text_row.get_node("Result/ResultA").set_text(str(test.result[2]))

		test_text_row.get_node("Percent/PercentE").set_text(percents[0])
		test_text_row.get_node("Percent/PercentC").set_text(percents[1])
		test_text_row.get_node("Percent/PercentA").set_text(percents[2])

		test_text_row.get_node("Grade/GradeLetter").set_text(grade)

		$Menu/TestsCont/TestsScroll/Tests.add_child(test_text_row)

func calculate_percents(res_points, max_points):
	var e = stepify((res_points[0] / max_points[0]) * 100, 1.0)
	var c = stepify((res_points[1] / max_points[1]) * 100, 1.0)
	var a = stepify((res_points[2] / max_points[2]) * 100, 1.0)
	
	var e_string = str(e) + "% "
	var c_string = str(c) + "% "
	var a_string = str(a) + "% "

	return [e_string, c_string, a_string]


func calculate_grade(res_points, limits):
	var e = res_points[0]
	var c = res_points[1]
	var a = res_points[2]
	
	var grade = "F"

	if (e + c + a) >= limits.E[0]:
		grade = "E"
	
	if (e + c + a) >= (limits.D[0] + limits.D[1]):
		if (c + a) >= limits.D[1]:
			grade = "D"
	
	if (e + c + a) >= (limits.C[0] + limits.D[1]):
		if (c + a) >= limits.C[1]:
			grade = "C"
	
	if (e + c + a) >= (limits.B[0] + limits.B[1] + limits.B[2]):
		if (c + a) >= (limits.B[1] + limits.B[2]):
			if a >= limits.B[2]:
				grade = "B"
	
	if (e + c + a) >= (limits.A[0] + limits.A[1] + limits.A[2]):
		if (c + a) >= (limits.A[1] + limits.A[2]):
			if a >= limits.A[2]:
				grade = "A"
	
	return grade


func _on_SaveButton_pressed():
	pass # Replace with function body.
