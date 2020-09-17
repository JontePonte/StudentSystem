extends ToolButton


# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()


func update_text():
	set_text(GlobalVars.activeDataFile)
