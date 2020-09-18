extends WindowDialog


func show_info():
	var student_dict = collect_info()

	# set popup menu header to student name
	$StudentInfoMenu/StudentInfoName.set_text(student_dict.first_name + " " + student_dict.last_name)




func collect_info():
	# Load students in the class into student_list
	var students_data = FileSys.student_data_load()
	var students_list = students_data.get(GlobalVars.activeClass).students
	
	# Collect student info in student_dict
	for student in students_list:
		if student.id_num == GlobalVars.activeStudentId:
			return student
