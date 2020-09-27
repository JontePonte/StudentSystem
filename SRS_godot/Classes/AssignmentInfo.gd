extends WindowDialog


onready var AssignmentName = get_node("Menu/TopVbox/TopHbox/AssignmentName")


func show_info():
	var data_dict = FileSys.student_data_load()
	var assignment_dict = data_dict.get(GlobalVars.activeClass).get("assignments").get(str(GlobalVars.activeAssignmentId))

	AssignmentName.set_text(assignment_dict.assignment_name)
	print_student_results(data_dict)
	print_assignment_description(assignment_dict)


func print_student_results(data_dict):
	pass


func print_assignment_description(assignment_dict):
	pass


func _on_Save_pressed():
	print("Save Assignment info")


func _on_Exit_pressed():
	hide()

	
func _on_Remove_pressed():
	$RemoveConfirm.popup_centered()


func _on_RemoveConfirm_confirmed():
	print("Remove Assignment")
