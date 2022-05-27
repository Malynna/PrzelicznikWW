extends Control

export (NodePath) onready var dropdown1 = get_node(dropdown1) as OptionButton
export (NodePath) onready var dropdown2 = get_node(dropdown2) as OptionButton
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

export (NodePath) onready var przelicznik = get_node(przelicznik) as Control

func _ready():
	add_items_to_dropdown()
#	print (WW_morning_string)

func add_items_to_dropdown():
	dropdown1.add_item("Rano ")
	dropdown1.add_item("Popołudniu")
	dropdown1.add_item("Wieczorem")
	dropdown1.add_item("Rano/2")
	dropdown1.add_item("Popołudniu/2")
	dropdown1.add_item("Wieczorem/2")
	dropdown1.add_item("Wpisz Ręcznie")
	dropdown1.select(6)
	dropdown2.add_item("Rano")
	dropdown2.add_item("Popołudniu")
	dropdown2.add_item("Wieczorem")
	dropdown2.add_item("Rano/2")
	dropdown2.add_item("Popołudniu/2")
	dropdown2.add_item("Wieczorem/2")
	dropdown2.add_item("Wpisz Ręcznie")

func calculate_WW_WBT_values():
	var WW_value = (Carbohydrates_value.value - Fiber_value.value)/10
	var kcal_value = (Carbohydrates_value.value*4 + Protein_value.value*4 + Fat_value.value*9)
	var WBT_value = (Fat_value.value*9 + Protein_value.value*4)/100
	var JI_time = (stepify(WBT_value,0.5))+2

	WW_WBT_full_values_box.visible = true

	WW_value_label.bbcode_text = "[color=#ef8522][b][i][center]WW = %s"  %WW_value
	WBT_value_label.bbcode_text = "[color=#ef8522][b][i][center]WBT = %s" %WBT_value
	kcal_value_label.bbcode_text = "[color=#ef8522][b][i][center]kcal = %s" %kcal_value
	JI_time_value_label.bbcode_text = "[color=#ef8522][b][i]posiłek będzie rozkładał się %s h" %JI_time

