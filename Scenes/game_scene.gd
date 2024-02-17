extends Node


var HUD : UIControl
var map : Map


func _ready():
	HUD = find_child('HUD')
	map = find_child('Map1')
	HUD.map = map

## ================================================================================================
##				EVENT
## ================================================================================================

func _on_hud_ui_control_event(event_data):
	match event_data:
		{"event":"build_tower", "tower":var tower, "position": var position}:
			build_tower(tower,position)
			
		{"event":"next_wave"}:
			start_next_wave()
			
		{"event":"play_game"}:
			_play()
		{"event":"pause_game"}:
			_pause()
		{"event":"fast_forward"}:
			_set_fast_forward(true)
		{"event":"fast_forward_cancel"}:
			_set_fast_forward(false)
			
		{"event":var event_name,..}:
			push_warning("Event :"+event_name+" is not handled by the game. Hence ignored")
		_:
			push_warning("Not an event")


## ================================================================================================
##				Game control
## ================================================================================================
func _set_fast_forward(fast_on):
	if fast_on:
		Engine.set_time_scale(2.0)
	else:
		Engine.set_time_scale(1.0)
	
func _pause():
	get_tree().paused = true

func _play():
	get_tree().paused = false




## ================================================================================================
##				building
## ================================================================================================
func build_tower(tower : Gun ,turret_position:Vector2):
	var valid = map.check_valid_position(turret_position)
	if valid:
		HUD.tower_preview_control.remove_child(tower)
		map.add_turret(tower, turret_position)
		
	else:
		tower.queue_free()

## ================================================================================================
##				WAVES
## ================================================================================================
var current_wave =0

var loaded_enemies = {}

var WAVE_DATA = [
			[[5,'BaseEnemy',0.3]]
			,[[15,'BaseEnemy',0.5]]
			,[[15,'BaseEnemy',0.3]]
			,[[20,'BaseEnemy',0.1]]
			,[[10,'BaseEnemy',0.1],[5,'BaseEnemy',0.5],[10,'BaseEnemy',0.1],[5,'BaseEnemy',1],[100,'BaseEnemy',0.02]]
			]

func load_enemy(enemy_name):
	if enemy_name in loaded_enemies:
		return loaded_enemies[enemy_name].instantiate()
	else:
		var enemy = load("res://Scenes/enemies/"+enemy_name+".tscn")
		loaded_enemies[enemy_name]=enemy
		return enemy.instantiate()
	

func start_next_wave():
	var wave = _retrieve_wave_data()
	current_wave+=1
	spawn_enemies(wave)

func _retrieve_wave_data():
	if current_wave< len(WAVE_DATA):
		return WAVE_DATA[current_wave]
	else:
		return []

func spawn_enemies(wave):
	for spawn in wave:
		assert(len(spawn)==3,'invalid wave data')
		var enemy_number :int = spawn[0] as int
		
		var enemy_interval  = spawn[2]
		for i in range(enemy_number):
			var enemy = load_enemy(spawn[1])
			map.add_enemy(enemy)
			await(get_tree().create_timer(enemy_interval).timeout)
		
		
		
	
