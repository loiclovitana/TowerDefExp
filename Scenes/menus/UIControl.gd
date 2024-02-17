class_name UIControl extends Control

signal ui_control_event(event_data)


func on_ui_control_event(event_data):
	ui_control_event.emit(event_data)
	
func on_new_game_pressed():
	ui_control_event.emit({"event":"new_game"})

func on_exit_pressed():
	ui_control_event.emit({"event":"exit"})
