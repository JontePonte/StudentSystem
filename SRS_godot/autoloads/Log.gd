extends Node


# Log debug message
func info(message):
	# only print if log is enabled
    if GlobalVars.enable_log:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("INFO:  ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)


# Log debug message
func debug(message):
	# only print if log is enabled and debug mode is on
    if GlobalVars.enable_log and GlobalVars.debug_mode:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("DEBUG: ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)


# Log warning message
func warning(message):
	# only print if log is enabled
    if GlobalVars.enable_log:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("WARN:  ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)


# Log critical message
func error(message):
	# only print if log is enabled
    if GlobalVars.enable_log:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("ERROR: ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)
