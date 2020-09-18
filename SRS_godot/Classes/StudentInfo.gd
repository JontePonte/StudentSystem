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
	print(student_dict)
