extends Node


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
