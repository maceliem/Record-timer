extends Control
class_name TimerPage

var time := 0
var highScore := 0
var fast = false
var button:Button

func _ready():
	MobileAds.config.banner.position = 0
	MobileAds.load_banner()
	$name.text = name

func _on_start_pressed():
	time = 0
	$VBoxContainer/Label.remove_theme_color_override("font_color")
	_updateTime(time, $VBoxContainer/Label)
	$Clock.start()
	$VBoxContainer/AspectRatioContainer/Start.visible = false
	$VBoxContainer/AspectRatioContainer/Stop. visible = true


func _on_clock_timeout():
	time += 1
	_updateTime(time, $VBoxContainer/Label)
	if fastOrLong(highScore, time):
		$VBoxContainer/Label.add_theme_color_override("font_color", Color(0, 223, 0))
	elif highScore != 0:
		$VBoxContainer/Label.add_theme_color_override("font_color", Color(193, 0, 0))

func _on_stop_pressed():
	$Clock.stop()
	$VBoxContainer/AspectRatioContainer/Start.visible = true
	$VBoxContainer/AspectRatioContainer/Stop. visible = false
	if fastOrLong(highScore, time) or highScore == 0:
		highScore = time
	_updateTime(highScore, $highScore)
	button.text = $name.text + "\n" + $highScore.text
	Data.saveProgram()
	
func _updateTime(val:int, elm:Label):
	var hour = floor(val/360000)
	var min = floor(val/6000) % 60
	var sek = val /100 % 60
	var percent = val % 100
	var text = ""
	if hour > 0:
		text += str(hour) + ":"
	if min < 10:
		text += "0" + str(min) + ":"
	else: 
		text += str(min) + ":"
	if sek < 10:
		text += "0" + str(sek) + "."
	else: 
		text += str(sek) + "."
	if percent < 10:
		text += "0" + str(percent)
	else:
		text += str(percent)
	elm.text = text

func fastOrLong(a, b):
	if fast:
		return a > b
	else:
		return b > a


func _on_check_button_toggled(button_pressed):
	fast = button_pressed


func _on_clear_pressed():
	time = 0
	highScore = 0
	$VBoxContainer/Label.remove_theme_color_override("font_color")
	_updateTime(time, $VBoxContainer/Label)
	_updateTime(highScore, $highScore)
	$VBoxContainer/AspectRatioContainer/Start.visible = true
	$VBoxContainer/AspectRatioContainer/Stop. visible = false


func _on_back_pressed():
	get_tree().root.add_child(Data.menu)
	get_tree().root.remove_child(self)


func _on_name_text_changed():
	name = $name.text
	button.text = name + "\n" + $highScore.text
	Data.saveProgram()
