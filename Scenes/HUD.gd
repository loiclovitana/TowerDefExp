extends UIControl

var building = false
var tower_preview_control : Control
var selectedTurret : Gun
var map : Map

var build_valid = false

func _init():
	pass

func _ready():
	tower_preview_control = find_child("TowerPreviewControl")
	


func _process(_delta):
	if building:
		update_building()
	
	

func update_building():
	var check_position = map.check_valid_position(get_global_mouse_position())
	
	tower_preview_control.set_position(check_position[1])
	
	if check_position[0] and not build_valid:
		selectedTurret.modulate = Color("d0ffc0ed")
		build_valid = true
	
	if (not check_position[0] ) and  build_valid:
		selectedTurret.modulate = Color("ff7e82")
	
	build_valid=check_position[0]
	

func on_ui_control_event(event_data):
	match event_data:
		{"event":"create_turret","turret_type":var turret_type}:
			start_build(turret_type)
		_:
			ui_control_event.emit(event_data)
	
func start_build(turret_type:PackedScene):
	if building==true:
		cancel_build()
	building=true
	build_valid=false
	tower_preview_control.set_position(get_global_mouse_position())
	selectedTurret = turret_type.instantiate()
	selectedTurret.set_name("TowerPreview")
	selectedTurret.modulate = Color("ff7e82")
	
	tower_preview_control.add_child(selectedTurret,true)
	



func cancel_build():
	building=false
	selectedTurret.queue_free()
	selectedTurret = null


func _unhandled_input(event):
	if building and event.is_action_released("ui_accept"):
		if build_valid:
			ui_control_event.emit({"event":"build_tower"
				,"tower":selectedTurret
				,"position":tower_preview_control.position})
			selectedTurret=null
			building=false
		else:
			cancel_build()


