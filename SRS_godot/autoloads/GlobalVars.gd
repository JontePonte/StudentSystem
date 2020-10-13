extends Node
# All global variables

var version = 0.2

var activeDataFile = ""
var activeClass = ""
var activeStudentId = 0
var activeTestId = 0
var activeAssignmentId = 0

var log_file_path = "user://logs/"
var log_enable_terminal = false
var log_enable_file = true
var log_debug_mode = true


func _ready():
    load_data_file_variables()


func load_data_file_variables():
    var data = FileSys.app_data_load()


    # -----------------------------------------------------
    # ---------- All variables are loaded here ------------
    # -----------------------------------------------------
    
    activeDataFile = data.active_data_file

    # -----------------------------------------------------
