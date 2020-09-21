extends Node


func save_active_check(student_dict, ActiveCheck):
	student_dict["active"] = ActiveCheck.pressed
	return student_dict


func save_name(student_dict, FirstName, LastName):
	var first_name = FirstName.text
	var last_name = LastName.text
	
	student_dict["first_name"] = first_name
	student_dict["last_name"] = last_name
	return student_dict


func save_info_text(student_dict, InfoVariables, info_key_list):
	# Create dictionary from the info text boxes
	var info_edit_box_dict = {}
	for child in InfoVariables.get_children():
		info_edit_box_dict[child.key_name] = child.get_node("Label").text

	# Update all student info changes in student dict
	for info_key in info_key_list:
		for student_key in student_dict.keys():
			if info_key == student_key:
				student_dict[student_key] = info_edit_box_dict.get(info_key)
	return student_dict
	
				
func save_student_test(student_dict, Tests):
	# Create a dictionary with all tests with results info from text edits
	var test_edit_box_dict = {}
	for child in Tests.get_children():
		test_edit_box_dict[child.key_name] = [
			int(child.get_node("TestInfo/Result/ResultE").text),
			int(child.get_node("TestInfo/Result/ResultC").text),
			int(child.get_node("TestInfo/Result/ResultA").text)]
	
	# Save student result
	for test_edited_id in test_edit_box_dict.keys():
		for test_stored_id in student_dict.get("tests").keys():
			if test_edited_id == test_stored_id:
				student_dict.get("tests").get(test_stored_id)["result"] = test_edit_box_dict[test_edited_id]
	

	# Create dictionary with check box status
	var test_check_box_dict = {}
	for child in Tests.get_children():
		test_check_box_dict[child.key_name] = child.get_node("TestInfo/Completed/CompletedCheck").pressed
	
	# Save chekc box status
	for test_check_id in test_check_box_dict.keys():
		for test_stored_id in student_dict.get("tests").keys():
			if test_check_id == test_stored_id:
				student_dict.get("tests").get(test_stored_id)["completed"] = test_check_box_dict[test_check_id]
	
	return student_dict


func save_student_assignment(student_dict, Assignments):
	# Create a dictionary with the assignments comment
	var assignment_completed_dict = {}
	for child in Assignments.get_children():
		assignment_completed_dict[child.key_name] = child.get_node("AssignmentInfo/Completed").pressed

	# Store the check button status
	for assignment_edited_id in assignment_completed_dict.keys():
		for assignment_stored_id in student_dict.get("assignments").keys():
			if assignment_edited_id == assignment_stored_id:
				student_dict.get("assignments").get(assignment_stored_id)["completed"] = assignment_completed_dict[assignment_edited_id]
	
	
	# Create a dictionary with the assignments comment
	var assignment_comment_dict = {}
	for child in Assignments.get_children():
		assignment_comment_dict[child.key_name] = child.get_node("AssignmentInfo/CommentScroll/CommentHBox/Comment").text

	# Store the comments
	for assignment_edited_id in assignment_comment_dict.keys():
		for assignment_stored_id in student_dict.get("assignments").keys():
			if assignment_edited_id == assignment_stored_id:
				student_dict.get("assignments").get(assignment_stored_id)["comment"] = assignment_comment_dict[assignment_edited_id]
	
	
	# Create a dictionary with the assignments grade
	var assignment_grade_dict = {}
	for child in Assignments.get_children():
		assignment_grade_dict[child.key_name] = child.get_node("AssignmentInfo/GradeHBox/GradeLetter").text

	# Store the grade
	for assignment_edited_id in assignment_comment_dict.keys():
		for assignment_stored_id in student_dict.get("assignments").keys():
			if assignment_edited_id == assignment_stored_id:
				student_dict.get("assignments").get(assignment_stored_id)["grade"] = assignment_grade_dict[assignment_edited_id]
	
	return student_dict


func save_comments(student_dict, Comments):
	var comment_edit_dict = {}
	for child in Comments.get_children():
		comment_edit_dict[child.key_name] = child.get_node("CommentHBox/Comment").text
	
	# Remove removed comments
	for comment_stored_key in student_dict.get("comments").keys():
		if not comment_stored_key in comment_edit_dict.keys():
			student_dict.get("comments").erase(comment_stored_key)

	# Add added comments
	for comment_edit_key in comment_edit_dict.keys():
		if not comment_edit_key in student_dict.get("comments").keys():
			student_dict.get("comments")[comment_edit_key] = comment_edit_dict.get(comment_edit_key)

	# Update comment texts
	for comment_id in comment_edit_dict.keys():
		for comment_stored_id in student_dict.get("comments").keys():
			if comment_id == comment_stored_id:
				student_dict.get("comments")[comment_stored_id] = comment_edit_dict.get(comment_id)
	
	return student_dict
