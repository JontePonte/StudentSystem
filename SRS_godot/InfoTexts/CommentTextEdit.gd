extends VBoxContainer


var key_name = ""


func _on_RemoveComment_pressed():
    get_parent().signal_comment_remove(key_name)
    queue_free()