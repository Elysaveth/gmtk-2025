extends Node
class_name TimeSystem

@export var time: TimeObject
@export var ticks_per_milisec := 0.001

@onready var start_time = Time.get_datetime_dict_from_system(true)
@onready var engine_start_time = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	# In game time measured in engine ticks
	#time.increase_by_milisec(delta * ticks_per_milisec)
	
	# In game time measured in delta OS miliseconds
	#time.increase_by_milisec(engine_start_time - Time.get_ticks_msec())

	# In game time measured in delta OS datetime
	time.increase_by_datetime(start_time, Time.get_datetime_dict_from_system(true))
