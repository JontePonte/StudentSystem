extends "res://addons/gut/test.gd"

# Test functions in StudentInfo

# ------------------------------------ Calculate percents ------------------------------------

func test_calculate_percents():
	
	var StudentInfo = preload("res://Classes/StudentInfo.tscn")
	var instance = StudentInfo.instance()
	get_tree().get_root().add_child(instance)

	var result = [4,4,4]
	var max_points = [10,10,10]
	var percents = instance.calculate_percents(result, max_points)
	var correct = ["40 %", "40 %", "40 %"]

	instance.queue_free()

	assert_eq(percents, correct)
