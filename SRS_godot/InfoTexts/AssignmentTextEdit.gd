extends VBoxContainer


var key_name = ""


func _on_Comment_text_changed(text_input):
    var text_corrected = AuxFunc.remove_invalid_characters_from_text(text_input)
    if text_input != text_corrected:
        Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
        $AssignmentInfo/CommentScroll/CommentHBox/Comment.set_text(text_corrected)


func _on_GradeLetter_text_changed(text_input):
    var text_corrected = AuxFunc.remove_invalid_characters_from_grade(text_input)
    if text_input != text_corrected:
        Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])	
        $AssignmentInfo/GradeHBox/GradeLetter.set_text(text_corrected)