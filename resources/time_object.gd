extends Resource
class_name TimeObject

var miliseconds := 0
@export_range(0, 59) var seconds := 0
@export_range(0, 59) var minutes := 0
@export_range(0, 23) var hours := 0
@export var days := 0
@export var months := 0
@export var years := 0

var delta_time := 0.0
var last_datetime: Dictionary


func increase_by_milisec(delta_milisec: float) -> void:
	delta_time += delta_milisec
	if delta_time < 1000:
		return
	
	var delta_in_seconds: int = delta_time / 1000
	delta_time -= delta_in_seconds * 1000

	seconds += delta_in_seconds
	minutes += seconds / 60
	hours += minutes / 60
	days += hours / 24
	
	seconds = seconds % 60
	minutes = minutes % 60
	hours = hours % 24

	#print_debug(str(days) + ":" + str(hours) + ":" + str(minutes) + ":" + str(seconds))


func increase_by_datetime(start_time: Dictionary, current_time: Dictionary) -> void:
	# Execute only when there is difference
	if last_datetime:
		if _check_if_difference(_delta_datetime_dictionary(last_datetime, current_time)):
			return
		
	var delta_datetime := _delta_datetime_dictionary(start_time, current_time)
		
	# Assign all values to each corresponding datetime value + carryover
	seconds = delta_datetime.seconds
	minutes = delta_datetime.minutes
	if seconds < 0:
		seconds += 60
		minutes -= 1
	hours = delta_datetime.hours
	if minutes < 0:
		minutes += 60
		hours -= 1
	days = delta_datetime.days
	if hours < 0:
		hours += 24
		days -= 1
	months = delta_datetime.months
	if days < 0:
		days += _calculate_days_in_month(delta_datetime)
		months -= 1
	years = delta_datetime.years
	if months < 0:
		months += 12
		years -= 1
		
	last_datetime = current_time
	
	#print_debug(str(days) + ":" + str(hours) + ":" + str(minutes) + ":" + str(seconds))


func _check_if_difference(delta_datetime: Dictionary) -> bool:
	delta_datetime.erase("current_year")
	delta_datetime.erase("current_month")
	for value in delta_datetime.values():
		if value != 0:
			return false
	return true

func _delta_datetime_dictionary(start: Dictionary, end: Dictionary) -> Dictionary:
	return {
		"current_year" : end.year,
		"current_month" : end.month,
		"years" : end.year - start.year,
		"months" : end.month - start.month,
		"days" : end.day - start.day,
		"hours" : end.hour - start.hour,
		"minutes" : end.minute - start.minute,
		"seconds" : end.second - start.second
	}

func _calculate_days_in_month(delta_datetime: Dictionary) -> int:
	#Number of days in each month
	var days_per_month := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	var leap_days_per_month := [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	if delta_datetime.current_year % 4 and \
	(not delta_datetime.current_year % 100 and delta_datetime.current_year % 400):
		return days_per_month[delta_datetime.current_month -1]
	else:
		return leap_days_per_month[delta_datetime.current_month -1]
