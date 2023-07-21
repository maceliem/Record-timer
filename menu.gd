extends Control

var timerPage = preload("res://timer.tscn")
var curButton

func _ready():
	if $GridContainer.get_child_count() > 1 : return
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
		button.size_flags_horizontal = 3
		$GridContainer.add_child(button)
		$GridContainer.move_child($GridContainer.get_node("addTimer"),$GridContainer.get_child_count()-1)

func _on_add_timer_pressed():
	$makeTimer.visible = true

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
	if curButton != null: 
		Data.timerList.erase(curButton)
		$GridContainer.remove_child(curButton)
		


func _on_type_pressed(fast:bool):
	$makeTimer.visible = false
	var button := Button.new()
	var timer:TimerPage = timerPage.instantiate()
	if $makeTimer/VBoxContainer/LineEdit.text != "":
		timer.name = $makeTimer/VBoxContainer/LineEdit.text 
	else: 
		timer.name = "Timer"
	timer.fast = fast
	button.text = "Timer \n 00:00.00"
	button.button_down.connect(buttonDown.bind(button))
	button.button_up.connect(buttonUp.bind(button))
	Data.timerList[button] = timer
	button.size_flags_horizontal = 3
	$GridContainer.add_child(button)
	$GridContainer.move_child($GridContainer.get_node("addTimer"),$GridContainer.get_child_count()-1)
	Data.menu = self
	Data.saveProgram()
	openTimer(button)
