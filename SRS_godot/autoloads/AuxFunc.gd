extends Node


# takes a dict of names and keys (numbers) and return an array of alphabetically sorted keys
func sort_students_by_name(students:Dictionary):

	var names = students.keys()
	names.sort()
	
	# Append the new sorted keys to sorted_keys
	var sorted_keys = []
	for key in names:
		sorted_keys.append(students[key])

	return sorted_keys


func create_unfinished_tests(data_dict):
	var tests_output = {}
	var tests_from_file = data_dict.get(GlobalVars.activeClass).get("tests")

	for key in tests_from_file:
		tests_output[key] = {
			"completed": false,
			"result": [0,0,0],
			"test_name": tests_from_file[key]["test_name"]}

	return tests_output


func create_unfinished_assignments(data_dict):
	var assignments_output = {}
	var assignments_from_file = data_dict.get(GlobalVars.activeClass).get("assignments")

	for key in assignments_from_file:
		assignments_output[key] = {
			"assignment_name": assignments_from_file[key]["assignment_name"],
			"comment": "",
			"completed": false,
			"grade": "-"}

	return assignments_output


func create_new_key_number(in_dict):
	var key_list = in_dict.keys()
	
	if key_list.empty():
		return "0"

	var highest_num = 0

	# return a string 1 higher than the highest id in the dict
	for key in key_list:
		if int(key) > highest_num:
			highest_num = int(key)
	
	return str(highest_num + 1)
