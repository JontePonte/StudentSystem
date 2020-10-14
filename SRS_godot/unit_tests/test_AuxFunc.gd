extends "res://addons/gut/test.gd"


# Test functions in AuxFunc


func test_sort_students_by_name():
	var students_unsorted = {
		"b": "2",
		"d": "4",
		"a": "1",
		"e": "5",
		"c": "3"}
	var students_keys_sorted = ["1","2","3","4","5"]
	var students_test = AuxFunc.sort_students_by_name(students_unsorted)

	assert_eq(students_test, students_keys_sorted)


# ------------------------------------ Calculate grade ------------------------------------
func get_limits():
	var grade_limits = {
		"A": [10,6,3],
		"B": [9,5,2],
		"C": [8,4,0],
		"D": [7,2,0],
		"E": [6,0,0]
	}
	return grade_limits

func test_calculate_grade_1():
	var res = [8,4,2]
	var grade_limits = get_limits()
	var completed = true
	var true_grade = "C"

	var grade = AuxFunc.calculate_grade(res,grade_limits,completed)

	assert_eq(grade, true_grade)

func test_calculate_grade_2():
	var res = [0,4,5]
	var grade_limits = get_limits()
	var completed = true
	var true_grade = "D"

	var grade = AuxFunc.calculate_grade(res,grade_limits,completed)

	assert_eq(grade, true_grade)

func test_calculate_grade_3():
	var res = [0,0,7]
	var grade_limits = get_limits()
	var completed = true
	var true_grade = "E"

	var grade = AuxFunc.calculate_grade(res,grade_limits,completed)

	assert_eq(grade, true_grade)

func test_calculate_grade_4():
	var res = [10,10,10]
	var grade_limits = get_limits()
	var completed = false
	var true_grade = "-"

	var grade = AuxFunc.calculate_grade(res,grade_limits,completed)

	assert_eq(grade, true_grade)


# ------------------------------------ Create test key number ------------------------------------
func test_create_new_key_number_1():
	var in_dict = {
		"1": "a",
		"2": "b",
		"3": "c",
		"4": "d",
		"5": "e",
		"6": "f"
	}
	var new_key_correct = "7"
	var new_key_test = AuxFunc.create_new_key_number(in_dict)

	assert_eq(new_key_test, new_key_correct)

func test_create_new_key_number_2():
	var in_dict = {
		"9": "i",
		"2": "b",
		"3": "c",
		"6": "f",
		"1": "a",
		"5": "e",
		"11": "k",
		"4": "d",
		"7": "g",
		"10": "j",
		"8": "h"
	}
	var new_key_correct = "12"
	var new_key_test = AuxFunc.create_new_key_number(in_dict)

	assert_eq(new_key_test, new_key_correct)

func test_create_new_key_number_error():
	var in_dict = {
		"1": "a",
		"2": "b",
		"3": "c",
		"john": "d",
		"5": "e",
		"6": "f"
	}
	var new_key_test = AuxFunc.create_new_key_number(in_dict)
	assert_null(new_key_test)


# ----------------------------- remove invalid characters from names -----------------------
func test_remove_invalid_characters_from_name_correct():
	var text_input = "John0123!?"
	var text_edited = AuxFunc.remove_invalid_characters_from_name(text_input)

	var text_correct = text_input
	assert_eq(text_edited, text_correct)


func test_remove_invalid_characters_from_name_string_markers_1():
	var text_input = "pppp'"
	var text_edited = AuxFunc.remove_invalid_characters_from_name(text_input)

	var text_correct = "pppp"
	assert_eq(text_edited, text_correct)


func test_remove_invalid_characters_from_name_string_markers_2():
	var text_input = 'pp"""pp"'
	var text_edited = AuxFunc.remove_invalid_characters_from_name(text_input)

	var text_correct = "pppp"
	assert_eq(text_edited, text_correct)


func test_remove_invalid_characters_from_name_every_character():
	var text_input = "p()[]{}.,:;/*+><~½%|&$¤#@´^§"
	var text_edited = AuxFunc.remove_invalid_characters_from_name(text_input)

	var text_correct = "p"
	assert_eq(text_edited, text_correct)
