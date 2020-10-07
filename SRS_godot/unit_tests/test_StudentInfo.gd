extends "res://addons/gut/test.gd"


# Test functions in StudentInfo


# ------------------------------------ Calculate percents ------------------------------------

func test_calculate_percents():
	
	var StudentInfo = preload("res://Classes/StudentInfo.tscn")
	var instance = StudentInfo.instance()
	var result = [4,4,4]
	var max_points = [10,10,10]
	var percents = instance.calculate_percents(result, max_points)
	instance.queue_free()
	
	var correct = ["40 %", "40 %", "40 %"]

	assert_eq(percents, correct)
