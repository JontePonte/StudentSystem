extends Node
# All global variables

var ActiveDataFile = ""


func _ready():
    load_data_file_variables()


func load_data_file_variables():
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

    ActiveDataFile = data.active_data_file
    print(ActiveDataFile)
