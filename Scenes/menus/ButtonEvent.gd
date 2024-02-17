class_name ButtonEvent extends TextureButton

@export_group("Event")
@export var event : String  = ""

@export var event_release : String  = ""

signal pressed_event(event_data)

func _ready():
	if event_release == '':
		self.pressed.connect(_button_pressed)
	elif is_toggle_mode():
		self.toggled.connect(_button_toggle)
	else:
		self.button_down.connect(_button_pressed)
	
func _button_pressed():
	pressed_event.emit({'event':event})

func _button_released():
	pressed_event.emit({'event':event_release})
	
func _button_toggle(toggle_on :bool):
	if toggle_on:
		_button_pressed()
	else:
		_button_released()
	



