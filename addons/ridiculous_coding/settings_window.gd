@tool
extends Window

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			print_debug("--> RC: Settings Menu Closed")
			queue_free()
