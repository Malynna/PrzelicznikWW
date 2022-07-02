extends Control

export (NodePath) onready var Hide_meal_button = get_node(JI_WW_Value) as CheckButton
export (NodePath) onready var Dropboxes = get_node(Dropboxes) as HBoxContainer
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
export (NodePath) onready var calculations_tab = get_node(calculations_tab) as Tabs


func _ready():
	add_items_to_dropdown()
	recalc()


func add_items_to_dropdown():
	Dropdown_WW.add_item("Rano")
	Dropdown_WW.add_item("Popołudniu")
	Dropdown_WW.add_item("Wieczorem")
	Dropdown_WW.add_item("Rano/2")
	Dropdown_WW.add_item("Popołudniu/2")
	Dropdown_WW.add_item("Wieczorem/2")
	Dropdown_WW.add_item("Wpisz lub wybierz z listy")
	Dropdown_WW.select(6)
	Dropdown_WBT.add_item("Rano")
	Dropdown_WBT.add_item("Popołudniu")
	Dropdown_WBT.add_item("Wieczorem")
	Dropdown_WBT.add_item("Rano/2")
	Dropdown_WBT.add_item("Popołudniu/2")
	Dropdown_WBT.add_item("Wieczorem/2")
	Dropdown_WBT.add_item("Wpisz lub wybierz z listy")
	Dropdown_WBT.select(6)
	

func recalc():
	var last_meal = DatabaseOperations.read_user_last_meal(1)
	JI_WW_Value.value = last_meal["JI_WW_Value"]
	JI_WBT_Value.value = last_meal["JI_WBT_Value"] 
	Carbohydrates_value.value = last_meal["Carbohydrates_value"] 
	Fiber_value.value = last_meal["Fiber_value"]
	Protein_value.value = last_meal["Protein_value"]
	Fat_value.value = last_meal["Fat_value"]


func calculate_WW_WBT_values():
	var WW_value = (Carbohydrates_value.value - Fiber_value.value)/10
	var kcal_value = (Carbohydrates_value.value*4 + Protein_value.value*4 + Fat_value.value*9)
	var WBT_kcal_value = (Fat_value.value*9 + Protein_value.value*4)
	var WBT_value = WBT_kcal_value/100
	var JI_time = (stepify(WBT_value,0.5))+2
	var JI_WW = WW_value * JI_WW_Value.value
	var JI_WBT = stepify(WBT_value * JI_WBT_Value.value,0.01)
	var JI_value = stepify(JI_WW + JI_WBT,0.01)
	
	WW_WBT_full_values_box.visible = true
	if JI_time <= 2: 
		JI_time_value_label.bbcode_text = "[color=#ef8522]Posiłek nie zawiera WBT, więc rozkładać się bedzie poniżej 2h"
	if JI_time >= 5:
		JI_time_value_label.bbcode_text = "[color=#ef8522]Posiłek będzie rozkładał się %sh[/color]" %JI_time
	else: #if JI_time > 2 and JI_time < 5:
		JI_time_value_label.bbcode_text = "[color=#ef8522]Posiłek będzie rozkładał się %sh" %JI_time
	JI_time_value_label.bbcode_text+= "\nW ostatecznej dawce insuliny należy uwzględnić jeszcze redukcję 10-50% na wysiłek fizyczny"
	if WW_value > 0:
		WW_value_label.bbcode_text = "[color=#ef8522][b][i][center]WW = %s"  %WW_value
		JI_value_label.bbcode_text = "[color=#ef8522][b][i][u]Należy podać %s JI[/u][/i][/b][/color]" %JI_value
		JI_value_label.bbcode_text+= "\nw tym [color=#ef8522][b][i]%s[/i][/b][/color] JI na WW " %JI_WW
		JI_value_label.bbcode_text+= "i [color=#ef8522][b][i]%s[/i][/b][/color] JI na WBT" %JI_WBT
	else:
		JI_time_value_label.bbcode_text += "\n[color=#ef8522]Brak WW, insulinę należy podać po około 2h[/color]"
		WW_value_label.bbcode_text = "[color=#ef8522][b][i][center]WW = 0"  	
		JI_value_label.bbcode_text = "[color=#ef8522][b][i][u]Należy podać %s JI[/u][/i][/b][/color]" %JI_WBT
		JI_value_label.bbcode_text+= "\nw tym [color=#ef8522][b][i]0[/i][/b][/color] JI na WW "
		JI_value_label.bbcode_text+= "i [color=#ef8522][b][i]%s[/i][/b][/color] JI na WBT" %JI_WBT
	WBT_value_label.bbcode_text = "[color=#ef8522][b][i][center]WBT = %s" %WBT_value
	kcal_value_label.bbcode_text = "[color=#ef8522][b][i][center]kcal = %s" %kcal_value
	DatabaseOperations.update_user_last_meal(JI_WW_Value.value, JI_WBT_Value.value, Carbohydrates_value.value, Fiber_value.value, Protein_value.value, Fat_value.value  )


	#tab2
	var Math3 = calculations_tab.Math3
	var JI_meal = calculations_tab.JI_meal
	if WW_value > 0:
		Math3.bbcode_text = "[color=#ef8522][b]%s WW[/b][/color] = (%s" %[WW_value, Carbohydrates_value.value]
		Math3.bbcode_text+= "-%s)/10 (węglowodany - błonnik)/10 " %[Fiber_value.value]
		Math3.bbcode_text+= "\n[color=#ef8522][b]%s JI[/b][/color] = %s*%s (WW * JI/WW) =>> należy podać JI na WW w posiłku" %[JI_WW, WW_value, JI_WW_Value.value]
	if WW_value < 0:
		Math3.bbcode_text = "[color=#ef8522][b]0 WW[/b][/color] = (%s" %Carbohydrates_value.value
		Math3.bbcode_text+= "-%s)/10 (węglowodany - błonnik)/10 " %[Fiber_value.value]
		Math3.bbcode_text+= "\n%s = %s*%s (WW * JI/WW) =>> Wartość ujemna może oznaczać błędne dane (Więcej błonnika od Węglowodanów)" %[JI_WW, WW_value, JI_WW_Value.value]
		Math3.bbcode_text+= "\nGdy Wartość WW jest niska, insulinę należy podać około 2h po posiłku"
	else:
		Math3.bbcode_text = "[color=#ef8522][b]0 WW[/b][/color] = (%s" %Carbohydrates_value.value
		Math3.bbcode_text+= "-%s)/10 (węglowodany - błonnik)/10 " %[Fiber_value.value]
		Math3.bbcode_text+= "\n[color=#ef8522][b]%s[/b][/color] = %s*%s (WW * JI/WW) =>> należałoby podać JI na WW w posiłku" %[JI_WW, WW_value, JI_WW_Value.value]
		Math3.bbcode_text+= "\nGdy Wartość WW jest niska, insulinę należy podać około 2h po posiłku"
	Math3.bbcode_text+= "\n%s kcal białkowo-tłuszczowych = (%s*4 +" %[WBT_kcal_value, Protein_value.value]
	Math3.bbcode_text+= " %s*9) (białko*4 + tłuszcz*9)" %Fat_value.value
	Math3.bbcode_text+= "\n[color=#ef8522][b]%s WBT[/b][/color] = "%WBT_value
	Math3.bbcode_text+= "(%s)/100 (kcal białkowotłuszczowe)/100" %WBT_kcal_value
	Math3.bbcode_text+= "\n[color=#ef8522][b]%s JI[/b][/color] = %s*%s (WBT * JI/WBT) =>> należy podać JI na WBT w posiłku" %[JI_WBT, WBT_value, JI_WBT_Value.value]		
	JI_meal.bbcode_text = "WBT rozkładają się po 2h od spożycia posiłku, 1WBT/1h"
	if JI_time <= 2: 
		JI_meal.bbcode_text+= "\nposiłek nie zawiera WBT, więc rozkładać się bedzie poniżej 2h"
	if JI_time > 2 and JI_time < 5:
		JI_meal.bbcode_text+= "\nPosiłek będzie rozkładał się %sh" %JI_time
	if JI_time >= 5:
		JI_meal.bbcode_text+= "\nPosiłek będzie rozkładał się %sh" %JI_time
		JI_meal.bbcode_text+= "\nW zależności od wykresu i czasu działania insuliny, należy zastanowić się "
		JI_meal.bbcode_text+= "nad podaniem mniejszej ilości insuliny na WBT i korekcie po czasie"
	JI_meal.bbcode_text+= "\nW ostatecznej dawce insuliny należy uwzględnić jeszcze redukcję 10-50% na wysiłek fizyczny"


func on_Dropdown_WW_item_selected(_index):
	if Dropdown_WW.get_selected_id() == 6:
		JI_WW_Value.editable = true
	else:
		JI_WW_Value.editable = false
		if Dropdown_WW.get_selected_id() == 0:
			JI_WW_Value.value = float(calculations_tab.WW_morning_cell.text)
		if Dropdown_WW.get_selected_id() == 1:
			JI_WW_Value.value = float(calculations_tab.WW_afternoon_cell.text)
		if Dropdown_WW.get_selected_id() == 2:
			JI_WW_Value.value = float(calculations_tab.WW_evening_cell.text)
		if Dropdown_WW.get_selected_id() == 3:
			JI_WW_Value.value = float(calculations_tab.WW_morning_cell.text)/2
		if Dropdown_WW.get_selected_id() == 4:
			JI_WW_Value.value = float(calculations_tab.WW_afternoon_cell.text)/2
		if Dropdown_WW.get_selected_id() == 5:
			JI_WW_Value.value = float(calculations_tab.WW_evening_cell.text)/2


func on_Dropdown_WBT_item_selected(_index):
	if Dropdown_WBT.get_selected_id() == 6:
		JI_WBT_Value.editable = true
	else:
		JI_WBT_Value.editable = false
		if Dropdown_WBT.get_selected_id() == 0:
			JI_WBT_Value.value = float(calculations_tab.WW_morning_cell.text)
		if Dropdown_WBT.get_selected_id() == 1:
			JI_WBT_Value.value = float(calculations_tab.WW_afternoon_cell.text)
		if Dropdown_WBT.get_selected_id() == 2:
			JI_WBT_Value.value = float(calculations_tab.WW_evening_cell.text)
		if Dropdown_WBT.get_selected_id() == 3:
			JI_WBT_Value.value = float(calculations_tab.WW_morning_cell.text)/2
		if Dropdown_WBT.get_selected_id() == 4:
			JI_WBT_Value.value = float(calculations_tab.WW_afternoon_cell.text)/2
		if Dropdown_WBT.get_selected_id() == 5:
			JI_WBT_Value.value = float(calculations_tab.WW_evening_cell.text)/2


func _on_Hide_meal_button_toggled(button_pressed):
	if button_pressed:
#		Dropboxes.visible = true
		Meal_values_box.visible = true
	else:
#		Dropboxes.visible = false
		Meal_values_box.visible = false


func reposition_dropdowns_selections():
	Dropdown_WW.select(6)
	Dropdown_WBT.select(6)
	JI_WW_Value.editable = true
	JI_WBT_Value.editable = true


func _on_JI_WW_Value_gui_input(_event):
	OS.show_virtual_keyboard("number", true)
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		if Dropdown_WW.get_selected_id() == 6:
			JI_WW_Value.get_line_edit().clear()
	

func _on_JI_WBT_Value_gui_input(_event):
	OS.show_virtual_keyboard("1,2,3,4,5,6,7,8,9,0,.", true)
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		if Dropdown_WBT.get_selected_id() == 6:	
			JI_WBT_Value.get_line_edit().clear()
	

func _on_Carbohydrates_value_gui_input(_event):
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		Carbohydrates_value.get_line_edit().clear()
		Carbohydrates_value.get_line_edit().virtual_keyboard_enabled = true


func _on_Fiber_value_gui_input(_event):
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		Fiber_value.get_line_edit().clear()


func _on_Protein_value_gui_input(_event):
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		Protein_value.get_line_edit().clear()


func _on_Fat_value_gui_input(_event):
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		Fat_value.get_line_edit().clear()
