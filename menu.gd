extends GridContainer

var timerPage = preload("res://timer.tscn")

func _on_add_timer_pressed():
	var button := Button.new()
	var timer:TimerPage = timerPage.instantiate()
	button.text = "New Timer \n 00:00.00"
	button.pressed.connect(openTimer.bind(button))
	Data.timerList[button] = timer
	add_child(button)
	move_child(get_node("addTimer"),get_child_count()-1)
	Data.menu = self

func openTimer(button):
	get_tree().root.add_child(Data.timerList[button])
	Data.timerList[button].button = button
	get_tree().root.remove_child(self)
