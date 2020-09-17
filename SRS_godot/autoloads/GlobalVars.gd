extends Node
# All global variables

var activeDataFile = ""


func _ready():
    load_data_file_variables()


func load_data_file_variables():
    var data = FileSys.save_data_load()


    # -----------------------------------------------------
    # ---------- All variables are loaded here ------------
    # -----------------------------------------------------
    
    activeDataFile = data.active_data_file

    # -----------------------------------------------------
