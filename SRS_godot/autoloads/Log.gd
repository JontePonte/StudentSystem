extends Node


# Log information message
func info(message):
	# only print if log is enabled and debug mode is on
    if GlobalVars.enable_log and GlobalVars.debug_mode:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("INFO: ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)


# Log warning message
func warning(message):
	# only print if log is enabled
    if GlobalVars.enable_log:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("WARNING: ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)


# Log critical message
func critical(message):
	# only print if log is enabled
    if GlobalVars.enable_log:
        # Get datetime to dictionary
        var dt=OS.get_datetime()
        # Format and print with message
        print("CRITICAL: ", "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], message)
