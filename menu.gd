extends Control

var timerPage = preload("res://timer.tscn")
var curButton

func _ready():
	$makeTimer/VBoxContainer/LineEdit.text = ""
	if $ScrollContainer/GridContainer.get_child_count() > 1 : return
	for savedTimer in Data.loadProgram():
		var timer:TimerPage = timerPage.instantiate()
		timer._updateTime(savedTimer.highScore, timer.get_node("highScore"))
		makeButton(savedTimer.fast, savedTimer.name, savedTimer.highScore)

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
		$confimDeleteTimer.visible = true
		$confimDeleteTimer/VBoxContainer/Label.text = "Are you sure you want to delete " + curButton.text.get_slice("\n",0) + "?"

func _on_type_pressed(fast:bool):
	$makeTimer.visible = false
	var txt = "Timer"
	if $makeTimer/VBoxContainer/LineEdit.text != "":
		txt = $makeTimer/VBoxContainer/LineEdit.text 
	var button = makeButton(fast, txt)
	Data.menu = self
	Data.saveProgram()
	openTimer(button)

func _on_cancel_pressed():
	$makeTimer.visible = false


func _on_keep_timer_pressed():
	$confimDeleteTimer.visible = false


func _on_delete_timer_pressed():
	Data.timerList.erase(curButton)
	$ScrollContainer/GridContainer.remove_child(curButton)
	$confimDeleteTimer.visible = false
	Data.saveProgram()

func makeButton(fast:bool, name := "Timer", highScore := 0):
	var button:Button = load("res://timerButton.tscn").instantiate()
	var timer:TimerPage = timerPage.instantiate()
	timer.fast = fast
	button.button_down.connect(buttonDown.bind(button))
	button.button_up.connect(buttonUp.bind(button))
	timer._updateTime(highScore, timer.get_node("highScore"))
	timer.name = name
	button.get_node("HBoxContainer/nameLabel").text = name
	button.get_node("HBoxContainer/scoreLabel").text = timer.get_node("highScore").text
	Data.timerList[button] = timer
	button.size_flags_horizontal = 3
	$ScrollContainer/GridContainer.add_child(button)
	$ScrollContainer/GridContainer.move_child($ScrollContainer/GridContainer.get_node("addTimer"),$ScrollContainer/GridContainer.get_child_count()-1)
	return button
