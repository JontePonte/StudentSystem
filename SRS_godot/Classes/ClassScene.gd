extends Control


func _ready():
	# Set header name
	var active_class = GlobalVars.activeClass
	$Menu/Header.set_text(active_class)

	create_student_buttons()


func create_student_buttons(): 
	var student_data = FileSys.student_data_load()
	var students_dict = student_data.get(GlobalVars.activeClass).students

	# Instance menu buttons and make them childs of scroll menu
	for id_num in students_dict:
		var scene = load("res://Buttons/StudentButton.tscn")
		var student_button = scene.instance()

		var student = students_dict.get(id_num)

		student_button.get_node("Label").set_text(student.first_name + " " + student.last_name)
		student_button.name = str(id_num)
		student_button.student_id = int(id_num)

		$Menu/RowsCont/StundetsCont/StudentsScroll/Students.add_child(student_button)


func _on_BackButton_pressed():
	var path = "res://Main.tscn"
	var _is_main = get_tree().change_scene(path)
