class_name NewTurretButton extends ButtonEvent

@export_group("Turret")
@export var turret_type : PackedScene 



func _button_pressed():
	pressed_event.emit({'event':"create_turret",'turret_type':turret_type})
