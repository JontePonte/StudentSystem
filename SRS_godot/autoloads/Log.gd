extends Node


var file = File.new()
var path = GlobalVars.log_file_path

func _ready():
	var dt = OS.get_datetime()
	path = path + "log" + "_%04d-%02d-%02d_%02d-%02d-%02d" % [dt.year,dt.month,dt.day,dt.hour,dt.minute,dt.second] + ".txt"
	print(path)


# Log warning message
func info(message):
	var dt=OS.get_datetime()
	# Format message
	var text_string = "INFO:  " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	log_message(text_string)


# Log debug message
func debug(message):
	if GlobalVars.log_debug_mode:
		var dt=OS.get_datetime()
		# Format message
		var text_string = "DEBUG: " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
		log_message(text_string)


# Log warning message
func warning(message):
	var dt=OS.get_datetime()
	# Format message
	var text_string = "WARN:  " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	print(text_string)


# Log critical message
func error(message):
	var dt=OS.get_datetime()
	# Format message
	var text_string = "ERROR: " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	print(text_string)


# Log message to output terminal and/or file
func log_message(text):
	if GlobalVars.log_enable_terminal:
		print(text)
	if GlobalVars.log_enable_file:
		var error = OK
		if not file.is_open():
			error = file.open(path, File.WRITE_READ)
		if error == OK:
			file.seek_end()
			file.store_line(text)


func close_log_file():
	file.close()

