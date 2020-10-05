extends "res://addons/gut/test.gd"


func test_assert_eq_number_not_equal():
	assert_eq(1, 2, "Should fail.  1 != 2")


func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

