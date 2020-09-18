extends Node
# All global variables

var activeDataFile = ""
var activeClass = ""
var activeStudentId = 0


func _ready():
    load_data_file_variables()


func load_data_file_variables():
    var data = FileSys.app_data_load()


    # -----------------------------------------------------
    # ---------- All variables are loaded here ------------
    # -----------------------------------------------------
    
    activeDataFile = data.active_data_file

    # -----------------------------------------------------
