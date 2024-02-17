class_name EnemyFollow extends PathFollow2D

@export var speed = 150
@export var hp = 15

@onready var health_bar = $HealthBar
var health_bar_relative_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value=hp
	health_bar.value=hp # Replace with function body.
	health_bar_relative_position = health_bar.position
	health_bar.top_level=true
	health_bar_relative_position = health_bar.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_progress(get_progress() + speed*delta)
	health_bar.value = hp
	health_bar.position=position + health_bar_relative_position
	
func on_hit(damage):
	hp -= damage
	if hp <= 0:
		destroy()

func destroy():
	self.queue_free()
