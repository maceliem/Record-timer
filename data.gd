extends Node

var timerList := {}

var menu

func saveProgram():
	var data = []
	for button in timerList:
		var timer = timerList[button]
		data.push_back({
			"name":timer.name, 
			"highScore": timer.highScore, 
			"fast": timer.fast
			})
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	
func loadProgram():
	if !FileAccess.file_exists("user://save_game.dat"): return
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_line())
	return json.get_data()

