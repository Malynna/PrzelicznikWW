extends Control

export (NodePath) onready var dropdown1 = get_node(dropdown1) as OptionButton
export (NodePath) onready var dropdown2 = get_node(dropdown2) as OptionButton
export (NodePath) onready var static2Box = get_node(static2Box) as VBoxContainer
export (NodePath) onready var weglowodany = get_node(weglowodany) as SpinBox
export (NodePath) onready var blonnik = get_node(blonnik) as SpinBox
export (NodePath) onready var bialko = get_node(bialko) as SpinBox
export (NodePath) onready var tluszcz = get_node(tluszcz) as SpinBox
export (NodePath) onready var WW_WBT_kcal_value_box = get_node(WW_WBT_kcal_value_box) as HBoxContainer
export (NodePath) onready var WW_value_label = get_node(WW_value_label) as RichTextLabel
export (NodePath) onready var WBT_value_label = get_node(WBT_value_label) as RichTextLabel
export (NodePath) onready var kcal_value_label = get_node(kcal_value_label) as RichTextLabel
export (NodePath) onready var JI_time_value_label = get_node(JI_time_value_label) as RichTextLabel

export (NodePath) onready var przelicznik = get_node(przelicznik) as Control

func _ready():
	add_items_to_dropdown()
#	print (WW_morning_string)

func add_items_to_dropdown():
	dropdown1.add_item("Rano " + str(przelicznik.WW_morning))
	dropdown1.add_item("Popołudniu")
	dropdown1.add_item("Wieczorem")
	dropdown1.add_item("Rano/2")
	dropdown1.add_item("Popołudniu/2")
	dropdown1.add_item("Wieczorem/2")
	dropdown1.add_item("Wpisz Ręcznie")
	dropdown1.select(5)
	dropdown2.add_item("Rano")
	dropdown2.add_item("Popołudniu")
	dropdown2.add_item("Wieczorem")
	dropdown2.add_item("Rano/2")
	dropdown2.add_item("Popołudniu/2")
	dropdown2.add_item("Wieczorem/2")
	dropdown2.add_item("Wpisz Ręcznie")

func calculate_WW_WBT_values():
	var WW_value = (weglowodany.value - blonnik.value)/10
	var kcal_value = (weglowodany.value*4 + tluszcz.value*9 + bialko.value*4)
	var WBT_value = (tluszcz.value*9 + bialko.value*4)/100
	var JI_time = (stepify(WBT_value,0.5))+2

	WW_WBT_kcal_value_box.visible = true
	JI_time_value_label.visible = true

	WW_value_label.bbcode_text = "[color=#ef8522][b][i][center]WW = %s"  %WW_value
	WBT_value_label.bbcode_text = "[color=#ef8522][b][i][center]WBT = %s" %WBT_value
	kcal_value_label.bbcode_text = "[color=#ef8522][b][i][center]kcal = %s" %kcal_value
	JI_time_value_label.bbcode_text = "[color=#ef8522][b][i]posiłek będzie rozkładał się %s h" %JI_time

