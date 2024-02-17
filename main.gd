extends Node


func exit():
	get_tree().quit()
	
func new_game():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/game_scene.tscn").instantiate()
	add_child(game_scene)

func process_event(event_data):
	match event_data:
		{"event":"exit"} :
			exit()
		{"event":"new_game"} :
			new_game()
		{"event":var event_name,..}:
			push_warning("Event :"+event_name+" is not handled by the game. Hence ignored")
		_:
			push_warning("Not an event")
			
		
