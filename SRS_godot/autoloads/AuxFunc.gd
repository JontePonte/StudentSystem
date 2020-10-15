extends Node


# takes a dict of names and keys (numbers) and return an array of alphabetically sorted keys
func sort_students_by_name(students:Dictionary):

	var names = students.keys()
	names.sort()
	
	# Append the new sorted keys to sorted_keys
	var sorted_keys = []
	for key in names:
		sorted_keys.append(students[key])
	
	Log.debug("Dictionary sorted " + str(names))
	return sorted_keys

	
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
	
	Log.debug("Grade %s calculated" % grade)
	return grade


func create_unfinished_tests(data_dict):
	var tests_output = {}
	var tests_from_file = data_dict.get(GlobalVars.activeClass).get("tests")

	for key in tests_from_file:
		tests_output[key] = {
			"completed": false,
			"result": [0,0,0],
			"test_name": tests_from_file[key]["test_name"]}

	Log.debug("Unfinished test created")
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

	Log.debug("Unfinished assignment created")
	return assignments_output


func create_new_key_number(in_dict):
	var key_list = in_dict.keys()
	
	# return first value if no values exists
	if key_list.empty():
		Log.info("Created first key in dictionary")
		return "0"

	# return null if some value is'nt an integer
	for key in key_list:
		if not key.is_valid_integer():
			Log.warning("Tried to create new dictionary key but dictionary included " + str(key))
			return null

	var highest_num = 0

	# get the highest number in the key_list
	for key in key_list:
		if int(key) > highest_num:
			highest_num = int(key)
	
	# Output the a string 1 higher than the highest number
	Log.debug("New dictionary with id %s key created" % str(highest_num + 1))
	return str(highest_num + 1)


func remove_invalid_characters_from_name(text_input):
	var text_edited = text_input
	
	# This is done the hard way. Could probably be done better
	# string markers
	text_edited = text_edited.replace('"', "")
	text_edited = text_edited.replace("'", "")
	# parentheses
	text_edited = text_edited.replace('(', "")
	text_edited = text_edited.replace(')', "")
	text_edited = text_edited.replace('[', "")
	text_edited = text_edited.replace(']', "")
	text_edited = text_edited.replace('{', "")
	text_edited = text_edited.replace('}', "")
	# stops and commas
	text_edited = text_edited.replace('.', "")
	text_edited = text_edited.replace(',', "")
	text_edited = text_edited.replace(':', "")
	text_edited = text_edited.replace(';', "")
	# math stuff
	text_edited = text_edited.replace('/', "")
	text_edited = text_edited.replace('*', "")
	text_edited = text_edited.replace('+', "")
	text_edited = text_edited.replace('>', "")
	text_edited = text_edited.replace('<', "")
	text_edited = text_edited.replace('~', "")
	text_edited = text_edited.replace('½', "")
	text_edited = text_edited.replace('%', "")
	# misc
	text_edited = text_edited.replace('|', "")
	text_edited = text_edited.replace('&', "")
	text_edited = text_edited.replace('$', "")
	text_edited = text_edited.replace('¤', "")
	text_edited = text_edited.replace('#', "")
	text_edited = text_edited.replace('@', "")
	text_edited = text_edited.replace('´', "")
	text_edited = text_edited.replace('^', "")
	text_edited = text_edited.replace('§', "")
	
	return text_edited


func remove_invalid_characters_from_text(text_input):
	var text_edited = text_input
	
	# Only the string markers are not allowed in comments
	text_edited = text_edited.replace('"', "")
	text_edited = text_edited.replace("'", "")
	
	return text_edited


func remove_invalid_characters_from_number(text_input):
	var text_edited = text_input
	
	# Spril string int first and second characters
	var character_1 = text_input.substr(0,1)
	var character_2 = text_input.substr(1,-1)	# second should only have lenght 1

	# Check if characters are integers and remove then if they are'nt
	if not character_1.is_valid_integer():
		text_edited = text_edited.replace(character_1,"")
	if not character_2.is_valid_integer():
		text_edited = text_edited.replace(character_2,"")
	
	return text_edited


func remove_invalid_characters_from_grade(text_input):
	var text_edited = text_input
	
	var allowed_characters = [
		"-","f","F","e","E","d","D","c","C","b","B","a","A","g","G","v","V","+","-"]

	# Spril string int first and second characters
	var character_1 = text_input.substr(0,1)
	var character_2 = text_input.substr(1,-1)	# second should only have lenght 1

	# Check if characters are integers and remove then if they are'nt
	if not character_1 in allowed_characters:
		text_edited = text_edited.replace(character_1,"")
	if not character_2 in allowed_characters:
		text_edited = text_edited.replace(character_2,"")
	
	return text_edited