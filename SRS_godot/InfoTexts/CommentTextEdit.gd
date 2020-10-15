extends VBoxContainer


var key_name = ""


func _on_Comment_text_changed(text_input):
    var text_corrected = AuxFunc.remove_invalid_characters_from_text(text_input)
    if text_input != text_corrected:
        Log.info("Removed invalid character(s) %s --> %s" % [text_input, text_corrected])
        $CommentHBox/Comment.set_text(text_corrected)


func _on_RemoveComment_pressed():
    queue_free()