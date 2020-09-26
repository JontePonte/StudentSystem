extends WindowDialog


onready var TestName = get_node("Menu/TopVbox/TopHbox/TestName")
onready var TestProperties = get_node("Menu/Center/TestProperties/TestPropertyScroll/TestPointsProperty")
onready var MaxPoints = get_node("Menu/Center/TestProperties/MaxPoints")

func show_info():
	var data_dict = FileSys.student_data_load()
	var test_dict = data_dict.get(GlobalVars.activeClass).get("tests").get(str(GlobalVars.activeTestId))

	TestName.set_text(test_dict.test_name)
	print_test_properties(test_dict)


func print_test_properties(test_dict):

	for child in TestProperties.get_children():
		child.queue_free()
	
	# Create max points property
	var max_points_text = "Max Points"
	var max_points_E = str(test_dict.get("max_points")[0])
	var max_points_C = str(test_dict.get("max_points")[1])
	var max_points_A = str(test_dict.get("max_points")[2])

	MaxPoints.get_node("Label").set_text(max_points_text)
	MaxPoints.get_node("LineEditE").set_text(max_points_E)
	MaxPoints.get_node("LineEditC").set_text(max_points_C)
	MaxPoints.get_node("LineEditA").set_text(max_points_A)

	# Print grade limits
	var grade_limits = test_dict.get("grade_limits")
	for key in grade_limits.keys():
		var limit = grade_limits[key]
		var points_E = str(limit[0])
		var points_C = str(limit[1])
		var points_A = str(limit[2])
		var label_text = '"' + key + '"' + "-limit:"

		var scene = load("res://InfoTexts/TestProperty.tscn")
		var property = scene.instance()
		property.name = key

		property.get_node("Label").set_text(label_text)
		property.get_node("LineEditE").set_text(points_E)
		property.get_node("LineEditC").set_text(points_C)
		property.get_node("LineEditA").set_text(points_A)

		TestProperties.add_child(property)


