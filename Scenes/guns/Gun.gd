class_name Gun extends Node2D

## STATS
@export var damage : int = 10
@export var fire_rate : float = 0.5

enum GUNSTATE {
	BUILDING,
	TARGETTING
}

var gun_state: GUNSTATE = GUNSTATE.BUILDING;
# Called when the node enters the scene tree for the first time.

@onready var shooting_range : Area2D = $Range
@onready var animation : AnimationPlayer = $GunAnimation
@onready var turret  = $Turret

var enemies_in_range =[]
var targeted_enemy = null
var _shoot_ready = true
var _delay_until_ready = 0

func _ready():
	shooting_range.body_entered.connect(_enemy_in_range)
	shooting_range.body_exited.connect(_enemy_exit_range)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	if gun_state == GUNSTATE.TARGETTING :
		_reload_shooting(delta)
		
		if _shoot_ready or not targeted_enemy :
			_choose_target() # only when shooting or no enemy_selected
		_display_range()
		_target_enemy()
		if _shoot_ready and targeted_enemy:
			_shoot()

func _reload_shooting(delta):
	if not _shoot_ready:
		_delay_until_ready -= delta
		if _delay_until_ready<0:
			_shoot_ready=true
	
	else:
		_delay_until_ready = -delta*0.5

func _shoot():
	_shoot_ready=false
	animation.play("Fire")
	_delay_until_ready += 1.0/fire_rate
	targeted_enemy.on_hit(damage)
	

func _choose_target():
	if enemies_in_range.is_empty():
		targeted_enemy=null
	for potential_target in enemies_in_range:
		if not targeted_enemy or potential_target.get_progress() > targeted_enemy.get_progress():
			targeted_enemy=potential_target


func _target_enemy():
	var ennemy_position = targeted_enemy.position if targeted_enemy else get_global_mouse_position();
	
	turret.look_at(ennemy_position)
	turret.rotation += deg_to_rad(90)
	
func _display_range():
	var display_condition = get_local_mouse_position().distance_to(Vector2(0,0))<30
	if shooting_range.visible!=display_condition:
		shooting_range.visible=display_condition

## ===============================================================================================
##      EVENT management
## ===============================================================================================

func _enemy_in_range(enemy):
	enemies_in_range.append(enemy.get_parent())

func _enemy_exit_range(enemy):
	if targeted_enemy==enemy.get_parent():
		targeted_enemy=null
	enemies_in_range.erase(enemy.get_parent())


