extends Control

export (NodePath) onready var JI_WW_Value = get_node(JI_WW_Value) as SpinBox
export (NodePath) onready var Dropdown_WW = get_node(Dropdown_WW) as OptionButton
export (NodePath) onready var JI_WBT_Value = get_node(JI_WBT_Value) as SpinBox
export (NodePath) onready var Dropdown_WBT = get_node(Dropdown_WBT) as OptionButton
export (NodePath) onready var Meal_values_box = get_node(Meal_values_box) as VBoxContainer
export (NodePath) onready var Carbohydrates_value = get_node(Carbohydrates_value) as SpinBox
export (NodePath) onready var Fiber_value = get_node(Fiber_value) as SpinBox
export (NodePath) onready var Protein_value = get_node(Protein_value) as SpinBox
export (NodePath) onready var Fat_value = get_node(Fat_value) as SpinBox
export (NodePath) onready var WW_WBT_full_values_box = get_node(WW_WBT_full_values_box) as VBoxContainer
export (NodePath) onready var WW_value_label = get_node(WW_value_label) as RichTextLabel
export (NodePath) onready var WBT_value_label = get_node(WBT_value_label) as RichTextLabel
export (NodePath) onready var kcal_value_label = get_node(kcal_value_label) as RichTextLabel
export (NodePath) onready var JI_time_value_label = get_node(JI_time_value_label) as RichTextLabel
export (NodePath) onready var JI_value_label = get_node(JI_value_label) as RichTextLabel
#scenes
export (NodePath) onready var przelicznik = get_node(przelicznik) as Control
#
export (NodePath) onready var WW_morning_cell = get_node(WW_morning_cell) as RichTextLabel
export (NodePath) onready var WW_afternoon_cell = get_node(WW_afternoon_cell) as RichTextLabel
export (NodePath) onready var WW_evening_cell = get_node(WW_evening_cell) as RichTextLabel


func _ready():
	add_items_to_dropdown()
	choose_WW_WBT_values()


func add_items_to_dropdown():
	Dropdown_WW.add_item("Rano")
	Dropdown_WW.add_item("Popołudniu")
	Dropdown_WW.add_item("Wieczorem")
	Dropdown_WW.add_item("Rano/2")
	Dropdown_WW.add_item("Popołudniu/2")
	Dropdown_WW.add_item("Wieczorem/2")
	Dropdown_WW.add_item("Wpisz ręcznie")
	Dropdown_WW.select(6)
	Dropdown_WBT.add_item("Rano")
	Dropdown_WBT.add_item("Popołudniu")
	Dropdown_WBT.add_item("Wieczorem")
	Dropdown_WBT.add_item("Rano/2")
	Dropdown_WBT.add_item("Popołudniu/2")
	Dropdown_WBT.add_item("Wieczorem/2")
	Dropdown_WBT.add_item("Wpisz ręcznie")
	Dropdown_WBT.select(6)
	

func choose_WW_WBT_values():
	pass

func calculate_WW_WBT_values():
	var WW_value = (Carbohydrates_value.value - Fiber_value.value)/10
	var kcal_value = (Carbohydrates_value.value*4 + Protein_value.value*4 + Fat_value.value*9)
	var WBT_value = (Fat_value.value*9 + Protein_value.value*4)/100
	var JI_time = (stepify(WBT_value,0.5))+2
	var JI_WW = WW_value * JI_WW_Value.value
	var JI_WBT = WBT_value * JI_WBT_Value.value
	var JI_value = stepify(JI_WW + JI_WBT,0.01)
	
	WW_WBT_full_values_box.visible = true

	WW_value_label.bbcode_text = "[color=#ef8522][b][i][center]WW = %s"  %WW_value
	WBT_value_label.bbcode_text = "[color=#ef8522][b][i][center]WBT = %s" %WBT_value
	kcal_value_label.bbcode_text = "[color=#ef8522][b][i][center]kcal = %s" %kcal_value
	JI_time_value_label.bbcode_text = "[color=#ef8522][b]posiłek będzie rozkładał się %s h" %JI_time
	JI_value_label.bbcode_text = "[color=#ef8522][b][i][u]Należy podać %s JI[/u][/i][/b][/color]" %JI_value
	JI_value_label.bbcode_text+= "\nw tym [color=#ef8522][b][i]%s[/i][/b][/color] JI na WW " %JI_WW
	JI_value_label.bbcode_text+= "i [color=#ef8522][b][i]%s[/i][/b][/color] JI na WBT" %JI_WBT

func on_Dropdown_WW_item_selected(_index):
	if Dropdown_WW.get_selected_id() == 6:
		JI_WW_Value.editable = true
	else:
		JI_WW_Value.editable = false
		if Dropdown_WW.get_selected_id() == 0:
			JI_WW_Value.value = float(WW_morning_cell.text)
		if Dropdown_WW.get_selected_id() == 1:
			JI_WW_Value.value = float(WW_afternoon_cell.text)
		if Dropdown_WW.get_selected_id() == 2:
			JI_WW_Value.value = float(WW_evening_cell.text)
		if Dropdown_WW.get_selected_id() == 3:
			JI_WW_Value.value = float(WW_morning_cell.text)/2
		if Dropdown_WW.get_selected_id() == 4:
			JI_WW_Value.value = float(WW_afternoon_cell.text)/2
		if Dropdown_WW.get_selected_id() == 5:
			JI_WW_Value.value = float(WW_evening_cell.text)/2


func on_Dropdown_WBT_item_selected(_index):
	if Dropdown_WBT.get_selected_id() == 6:
		JI_WBT_Value.editable = true
	else:
		JI_WBT_Value.editable = false
		if Dropdown_WBT.get_selected_id() == 0:
			JI_WBT_Value.value = float(WW_morning_cell.text)
		if Dropdown_WBT.get_selected_id() == 1:
			JI_WBT_Value.value = float(WW_afternoon_cell.text)
		if Dropdown_WBT.get_selected_id() == 2:
			JI_WBT_Value.value = float(WW_evening_cell.text)
		if Dropdown_WBT.get_selected_id() == 3:
			JI_WBT_Value.value = float(WW_morning_cell.text)/2
		if Dropdown_WBT.get_selected_id() == 4:
			JI_WBT_Value.value = float(WW_afternoon_cell.text)/2
		if Dropdown_WBT.get_selected_id() == 5:
			JI_WBT_Value.value = float(WW_evening_cell.text)/2
