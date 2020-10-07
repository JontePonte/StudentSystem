extends "res://addons/gut/test.gd"

# Test functions in FileSys


# ------------------------------------ student_data_load ------------------------------------

func test_student_data_load_first_has_assignments():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[0]

	assert_has(data[last_key], "assignments")

func test_student_data_load_first_has_students():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[0]

	assert_has(data[last_key], "students")

func test_student_data_load__first_has_tests():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[0]

	assert_has(data[last_key], "tests")

func test_student_data_load_last_has_assignments():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[-1]

	assert_has(data[last_key], "assignments")

func test_student_data_load_last_has_students():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[-1]

	assert_has(data[last_key], "students")

func test_student_data_load__last_has_tests():
	var data = FileSys.student_data_load()
	var last_key = data.keys()[-1]

	assert_has(data[last_key], "tests")

