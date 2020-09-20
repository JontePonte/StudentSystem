extends WindowDialog


onready var InfoKeys = get_node("Menu/InfoHBox/InfoKeys")
onready var InfoVariables = get_node("Menu/InfoHBox/InfoVariables")
onready var Tests = get_node("Menu/TestsCont/TestsScroll/Tests")
onready var Comments = get_node("Menu/CommentsCont/CommentsScroll/Comments")
onready var ActiveCheck = get_node("Menu/NameHeader/ActiveCheck")
onready var FirstName = get_node("Menu/NameHeader/FirstName")
onready var LastName = get_node("Menu/NameHeader/LastName")


# lists of what will be displayed under the header
var info_key_list_nice_names = ["Class", "Email", "Pers Nr"]
var info_key_list = ["class", "email", "pers_nr"]


func show_info():
	var student_dict = collect_info()

	# set popup menu header to student name
	$Menu/NameHeader/FirstName.set_text(student_dict.first_name)
	$Menu/NameHeader/LastName.set_text(student_dict.last_name)
	$Menu/NameHeader/ActiveCheck.pressed = student_dict.get("active")

	print_student_info(student_dict)
	print_test_info(student_dict)
	print_comments(student_dict)


func collect_info():
	# Load students in the class into student_list
	var students_data = FileSys.student_data_load()
	var students_dict = students_data.get(GlobalVars.activeClass).students
	
	# Collect student info in student_dict
	for id_num in students_dict:
		var student = students_dict.get(id_num)
		if int(id_num) == GlobalVars.activeStudentId:
			return student


func print_student_info(student_dict):
	# Clear any old info
	for child in InfoKeys.get_children():
		child.queue_free()
	for child in InfoVariables.get_children():
		child.queue_free()

	
	# Create lists for keys and variables
	var info_variable_list = [
		str(student_dict.get(info_key_list[0])),
		str(student_dict.get(info_key_list[1])),
		str(student_dict.get(info_key_list[2]))]
	
	
	# Print class, email and personal number
	for info_key in info_key_list_nice_names:
		var scene = load("res://InfoTexts/StudentInfoText.tscn")
		var info_text = scene.instance()

		info_text.get_node("Label").set_text(info_key)
		InfoKeys.add_child(info_text)

	# print the info and store key name in 
	for i in info_variable_list.size():
		var scene = load("res://InfoTexts/StudentInfoTextEdit.tscn")
		var info_text = scene.instance()

		info_text.get_node("Label").set_text(info_variable_list[i])
		info_text.key_name = info_key_list[i]
		InfoVariables.add_child(info_text)
	

func print_test_info(student_dict):
	# Clear old tests in pop up box
	for child in $Menu/TestsCont/TestsScroll/Tests.get_children():
		child.queue_free()

	var tests_dict = student_dict.get("tests")
	
	for test_index in tests_dict:
		var test = tests_dict.get(test_index)
		var scene = load("res://InfoTexts/TestInfoTextEdit.tscn")
		var test_text_row = scene.instance()
		
		# Extract max points and grade limits from data file
		var max_points = []
		var grade_limits = {}
		var data_dict = FileSys.student_data_load()
		for test_base_index in data_dict.get(GlobalVars.activeClass).get("tests"):
			var test_base = data_dict.get(GlobalVars.activeClass).get("tests").get(test_base_index)
			if test.test_name == test_base.test_name:
				max_points = test_base.get("max_points")
				grade_limits.E = test_base.get("grade_limits").get("E")
				grade_limits.D = test_base.get("grade_limits").get("D")
				grade_limits.C = test_base.get("grade_limits").get("C")
				grade_limits.B = test_base.get("grade_limits").get("B")
				grade_limits.A = test_base.get("grade_limits").get("A")
		
		
		var percents = calculate_percents(test.result, max_points)
		var grade = calculate_grade(test.result, grade_limits, test.completed)
		
		# Add all texts to text_text row
		test_text_row.get_node("TestInfo/Name").set_text(test.test_name)

		test_text_row.get_node("TestInfo/Max/MaxE").set_text(str(max_points[0]))
		test_text_row.get_node("TestInfo/Max/MaxC").set_text(str(max_points[1]))
		test_text_row.get_node("TestInfo/Max/MaxA").set_text(str(max_points[2]))

		test_text_row.get_node("TestInfo/Completed/CompletedCheck").pressed = test.completed
		
		test_text_row.get_node("TestInfo/Result/ResultE").set_text(str(test.result[0]))
		test_text_row.get_node("TestInfo/Result/ResultC").set_text(str(test.result[1]))
		test_text_row.get_node("TestInfo/Result/ResultA").set_text(str(test.result[2]))

		test_text_row.get_node("TestInfo/Percent/PercentE").set_text(percents[0])
		test_text_row.get_node("TestInfo/Percent/PercentC").set_text(percents[1])
		test_text_row.get_node("TestInfo/Percent/PercentA").set_text(percents[2])

		test_text_row.get_node("TestInfo/Grade/GradeLetter").set_text(grade)
		
		test_text_row.key_name = test_index
		Tests.add_child(test_text_row)


func print_comments(student_dict):
	# Clear old comments in pop up box
	for child in $Menu/CommentsCont/CommentsScroll/Comments.get_children():
		child.queue_free()

	var comments_dict = student_dict.get("comments")
	
	for comment_index in comments_dict:
		var comment = comments_dict.get(comment_index)
		var scene = load("res://InfoTexts/CommentTextEdit.tscn")
		var comment_row = scene.instance()
		print(comment)

		comment_row.get_node("CommentHBox/Comment").set_text(comment)
		comment_row.key_name = comment_index

		Comments.add_child(comment_row)


func calculate_percents(res_points, max_points):
	# Calculate each perent
	var e = stepify((res_points[0] / max_points[0]) * 100, 1.0)
	var c = stepify((res_points[1] / max_points[1]) * 100, 1.0)
	var a = stepify((res_points[2] / max_points[2]) * 100, 1.0)

	# Set different numbers of spaces if below 10 or above 100
	var e_string = str(e) + " %"
	if e < 10:
		e_string = str(e) + "  %"
	elif e >= 100:
		e_string = str(e) + "%"
	
	var c_string = str(c) + " %"
	if c < 10:
		c_string = str(c) + "  %"
	elif c >= 100:
		c_string = str(c) + "%"
	
	var a_string = str(a) + " %"
	if a < 10:
		a_string = str(a) + "  %"
	elif a >= 100:
		a_string = str(a) + "%"

	return [e_string, c_string, a_string]


func calculate_grade(res_points, limits, completed):
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
	
	if not completed:
		grade = "-"

	return grade


func _on_SaveButton_pressed():
	var data_dict = FileSys.student_data_load()
	var student_dict = collect_info()
	
	# Update student dictionar with the new information calld from SaveFunc auoload
	student_dict = SaveFunc.save_active_check(student_dict, ActiveCheck)
	student_dict = SaveFunc.save_name(student_dict, FirstName, LastName)
	student_dict = SaveFunc.save_info_text(student_dict, InfoVariables, info_key_list)
	student_dict = SaveFunc.save_student_test(student_dict, Tests)
	student_dict = SaveFunc.save_comments(student_dict, Comments)
	
	# update data_dict and save the updated json
	data_dict.get(GlobalVars.activeClass).students[str(GlobalVars.activeStudentId)] = student_dict
	FileSys.student_data_save(data_dict)
	
	# Update test info screen
	print_test_info(student_dict)
	# Update student list
	get_parent().create_student_buttons()
	
	
