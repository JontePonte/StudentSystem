extends HBoxContainer


func _on_LineEditE_text_changed(text_input):
	var text_corrected = AuxFunc.remove_invalid_characters_from_number(text_input)
	if text_input != text_corrected:
		Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
		$LineEditE.set_text(text_corrected)
	
func _on_LineEditC_text_changed(text_input):
	var text_corrected = AuxFunc.remove_invalid_characters_from_number(text_input)
	if text_input != text_corrected:
		Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
		$LineEditC.set_text(text_corrected)
		
func _on_LineEditA_text_changed(text_input):
	var text_corrected = AuxFunc.remove_invalid_characters_from_number(text_input)
	if text_input != text_corrected:
		Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
		$LineEditA.set_text(text_corrected)