extends HBoxContainer


var key_name = ""


func _on_Grade_text_changed(text_input):
    var text_corrected = AuxFunc.remove_invalid_characters_from_grade(text_input)
    if text_input != text_corrected:
        Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
        $Grade.set_text(text_corrected)
