extends GridContainer

var timerPage = preload("res://timer.tscn")
var curButton

func _ready():
	if get_child_count() > 2 : return
	for savedTimer in Data.loadProgram():
		var button := Button.new()
		var timer:TimerPage = timerPage.instantiate()
		timer.name = savedTimer.name
		timer.highScore = savedTimer.highScore
		timer.fast = savedTimer.fast
		timer._updateTime(savedTimer.highScore, timer.get_node("highScore"))
		button.text = savedTimer.name + "\n" + timer.get_node("highScore").text
		button.button_down.connect(buttonDown.bind(button))
		button.button_up.connect(buttonUp.bind(button))
		Data.timerList[button] = timer
		add_child(button)
		move_child(get_node("addTimer"),get_child_count()-1)

func _on_add_timer_pressed():
	var button := Button.new()
	var timer:TimerPage = timerPage.instantiate()
	timer.name = "New Timer"
	button.text = "New Timer \n 00:00.00"
	button.button_down.connect(buttonDown.bind(button))
	button.button_up.connect(buttonUp.bind(button))
	Data.timerList[button] = timer
	add_child(button)
	move_child(get_node("addTimer"),get_child_count()-1)
	Data.menu = self
	Data.saveProgram()

func buttonDown(button):
	$Timer.start()
	curButton = button

func buttonUp(button):
	if !$Timer.is_stopped():
		$Timer.stop()
		curButton = null
		openTimer(button)

func openTimer(button):
	get_tree().root.add_child(Data.timerList[button])
	Data.timerList[button].button = button
	get_tree().root.remove_child(self)
	Data.menu = self


func _on_timer_timeout():
	if curButton != null: remove_child(curButton)
