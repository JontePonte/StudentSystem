extends Node


var path = GlobalVars.log_file_path


# Log warning message
func info(message):
	var dt=OS.get_datetime() # Get datetime to dictionary
	# Format message
	var text_string = "INFO:  " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	log_message(text_string)


# Log debug message
func debug(message):
	if GlobalVars.log_debug_mode:
		var dt=OS.get_datetime() # Get datetime to dictionary
		# Format message
		var text_string = "DEBUG: " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
		log_message(text_string)


# Log warning message
func warning(message):
	var dt=OS.get_datetime() # Get datetime to dictionary
	# Format message
	var text_string = "WARN:  " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	print(text_string)


# Log critical message
func error(message):
	var dt=OS.get_datetime() # Get datetime to dictionary
	# Format message
	var text_string = "ERROR: " + "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second] + message
	print(text_string)


# Log message to output terminal and/or file
func log_message(text):
	if GlobalVars.log_enable_terminal:
		print(text)
	if GlobalVars.log_enable_file:
		pass


func open_log_file():
	var file = File.new()


func close_log_file():
	print("close file")

