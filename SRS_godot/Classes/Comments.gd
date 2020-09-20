extends VBoxContainer

signal comment_remove(key_name)

func signal_comment_remove(key_name):
	emit_signal("comment_remove", key_name)