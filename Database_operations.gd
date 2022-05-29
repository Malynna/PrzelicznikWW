extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var sysdate = _datetime_to_string(OS.get_datetime())
var db_name = "user://KDD_database.db" 
#var db_name = "res://KDD_database.db" 


func _ready():
#	var dir = Directory.new() 
#	dir.copy("res://KDD_database.gd", "user://KDD_database.db")
	if Directory.new().file_exists(db_name):
		print("pass")
	else:
		db = SQLite.new()
		db.path = db_name
		db.open_db()
		var ct = "CREATE TABLE main (user_id integer PRIMARY KEY AUTOINCREMENT,user_name text, "
		ct += "DDI_value float,JI_WW_Value float,JI_WBT_Value float,Carbohydrates_value float, "
		ct += "Fiber_value float,Protein_value float,Fat_value float,created_date datetime,updated_date datetime); "
		db.query(ct)
		insert_into_player_info()

func insert_into_player_info():
	_read_from_SQL()
	var columns = {"DDI_value" : 66, "JI_WW_Value":0.32, "JI_WBT_Value":0.32, "Carbohydrates_value":20,"Fiber_value":3, "Fat_value":9, "Protein_value":9}
	db.insert_rows("main", [columns])
	db.close_db()


func _read_from_SQL():
	db = SQLite.new()
	db.path = db_name
	db.open_db()


func _sql_select(query):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query(query)
	for i in range(0, db.query_result.size()):
		var _data = db.query_result[i]
	return db.query_result
	
	
func read_user_DDI():
	var select = "SELECT DDI_value " 
	var from = "FROM main "
	var where = ("WHERE user_id = '%s';" % 1)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array[0]	
	
	
func read_user_last_meal(user_id):
	var select = "SELECT Carbohydrates_value, Fiber_value, Protein_value, " 
	select += "Fat_value, JI_WW_Value, JI_WBT_Value "
	var from = "FROM main "
	var where = ("WHERE user_id = '%s';" % user_id)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array[0]	
	
	
func update_user_DDI(value):
	_read_from_SQL()
	var condition = ("user_id = '%s'" % 1)
	var columns = {"DDI_value" :value}
	db.update_rows("main", condition, columns)
	db.close_db()
	

func update_user_last_meal(JI_WW_Value, JI_WBT_Value, Carbohydrates_value, 
						Fiber_value, Protein_value, Fat_value):
	_read_from_SQL()
	var condition = ("user_id = '%s'" % 1)
	var columns = {"JI_WW_Value":JI_WW_Value,"JI_WBT_Value":JI_WBT_Value,
	"Carbohydrates_value":Carbohydrates_value,"Fiber_value":Fiber_value,
	"Protein_value":Protein_value,"Fat_value":Fat_value}
	db.update_rows("main", condition, columns)
	db.close_db()
	

func _datetime_to_string(date):
	if (
		date.has("year")
		and date.has("month")
		and date.has("day")
		and date.has("hour")
		and date.has("minute")
		and date.has("second")
	):
		# Date and time.
		return "{year}-{month}-{day} {hour}:{minute}:{second}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})
	else :
		print ("Bad sysdate")
