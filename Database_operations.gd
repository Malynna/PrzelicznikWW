extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var sysdate = _datetime_to_string(OS.get_datetime())
var db_name = "res://KDD_database.db" 
var packaged_db_name := "res://data_to_be_packaged"
var json_name := "res://test_backup.json"


func _ready():
	create_new_database_file()
	if OS.get_name() in ["Android", "iOS", "HTML5"]:  #in ["Android", "iOS", "HTML5", "Windows"]:
		copy_data_to_user()
		db_name = "user://KDD_database.db"
		json_name = "user://KDD_database.json"
		create_new_database_file()
	else:
		db_name = "user://KDD_database.db"
		json_name = "user://KDD_database.json"
		copy_data_to_user()
	
func copy_data_to_user() -> void:
	var data_path := "res://data"
	var copy_path := "user://data"
	var dir = Directory.new()
	dir.make_dir(copy_path)
	if dir.open(data_path) == OK:
		dir.list_dir_begin();
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				pass
			else:
				print("Copying " + file_name + " to /user-folder")
				dir.copy(data_path + "/" + file_name, copy_path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
func create_new_database_file():
	if Directory.new().file_exists(db_name):
		print("File exists")
	else:
		var table_dict : Dictionary = Dictionary()
		var table_name := "main"
		db = SQLite.new()
		db.path = db_name
#		db.verbosity_level = verbosity_level
		db.open_db()
		table_dict["user_id"] = {"data_type":"int", "primary_key": true, "not_null": true}
		table_dict["DDI_value"] = {"data_type":"float", "not_null": true}
		table_dict["JI_WW_Value"] = {"data_type":"float", "not_null": true}
		table_dict["JI_WBT_Value"] = {"data_type":"float", "not_null": true}
		table_dict["Carbohydrates_value"] = {"data_type":"float", "not_null": true}
		table_dict["Fiber_value"] = {"data_type":"float", "not_null": true}
		table_dict["Fat_value"] = {"data_type":"float", "not_null": true}
		table_dict["Protein_value"] = {"data_type":"float", "not_null": true}
		table_dict["created_date"] = {"data_type":"datetime"}
		table_dict["updated_date"] = {"data_type":"datetime"}
		db.create_table(table_name, table_dict)
		var columns = {"DDI_value" : 66, "JI_WW_Value":0.32, "JI_WBT_Value":0.32, "Carbohydrates_value":20,"Fiber_value":3, "Fat_value":9, "Protein_value":9}
		db.insert_rows("main", [columns])
		db.export_to_json("user://test_backup_new")
#		db.export_to_json(json_name + "_new")
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
