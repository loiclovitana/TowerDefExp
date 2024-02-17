class_name Map extends Node2D

var ground :TileMap
var towerExclusion : TileMap
var turrets  
@onready var path = $Path

# Called when the node enters the scene tree for the first time.
func _ready():
	ground= find_child("Ground")
	towerExclusion = find_child("TowerExclusion")
	turrets = find_child('Turrets')


func add_turret(tower,turret_position):
	var valid_position = check_valid_position(turret_position)
	if valid_position[0]:
		turrets.call_deferred("add_child",tower)
		tower.set_position(valid_position[1])
		tower.gun_state = tower.GUNSTATE.TARGETTING
		tower.modulate = Color("ffffffff")
		towerExclusion.set_cell(0,towerExclusion.local_to_map(turret_position),2,Vector2i(15,0))
		return true
	else:
		return false

func check_valid_position(position_to_check):
	var cell_for_tower = towerExclusion.local_to_map(position_to_check)
	var cell_position = towerExclusion.map_to_local(cell_for_tower)
	if towerExclusion.get_cell_source_id(0,cell_for_tower)==-1:
		return [true,cell_position]
	else:
		return [false,cell_position]
		

func add_enemy(enemy):
	path.add_child(enemy,true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
