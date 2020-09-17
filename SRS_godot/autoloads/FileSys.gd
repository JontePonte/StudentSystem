extends Node


func change_active_data_file(new_file_name):
	GlobalVars.activeDataFile = new_file_name

	# Save the new file name in AppData.json
	var data = app_data_load()
	data.active_data_file = new_file_name
	app_data_save(data)


func student_data_save(data):
	var path = GlobalVars.activeDataFile
	var s_data = File.new()
	if not s_data.file_exists(path):
		return
	s_data.open(path, File.WRITE)

	s_data.store_line(to_json(data))
	s_data.close()


func student_data_load():
	var path = GlobalVars.activeDataFile
	var s_data = File.new()
	if not s_data.file_exists(path):
	    return
	s_data.open(path, File.READ)
    # The data is stored in "text"
	var text = s_data.get_as_text()
	s_data.close()

    # Unpack information to dict data
	var data = parse_json(text)
	return data


func app_data_save(data):
	var path = "res://AppData.json"
	var app_data = File.new()
	if not app_data.file_exists(path):
		return
	app_data.open(path, File.WRITE)

	app_data.store_line(to_json(data))
	app_data.close()


func app_data_load():
	var path = "res://AppData.json"
	var app_data = File.new()
	if not app_data.file_exists(path):
	    return
	app_data.open(path, File.READ)
    # The data is stored in "text"
	var text = app_data.get_as_text()
	app_data.close()

    # Unpack information to dict data
	var data = parse_json(text)
	return data
