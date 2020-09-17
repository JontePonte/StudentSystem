extends Node


func change_active_data_file(new_file_name):
	GlobalVars.activeDataFile = new_file_name

	# Save the new file name in SaveData.json
	var data = save_data_load()
	data.active_data_file = new_file_name
	save_data_save(data)


func save_data_save(data):
	var path = "res://SaveData.json"
	var save_data = File.new()
	if not save_data.file_exists(path):
		return
	save_data.open(path, File.WRITE)

	save_data.store_line(to_json(data))
	save_data.close()


func save_data_load():
	var path = "res://SaveData.json"
	var save_data = File.new()
	if not save_data.file_exists(path):
	    return
	save_data.open(path, File.READ)
    # The data is stored in "text"
	var text = save_data.get_as_text()
	save_data.close()

    # Unpack information to dict data
	var data = parse_json(text)
	return data
