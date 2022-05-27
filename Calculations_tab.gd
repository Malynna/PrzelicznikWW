extends Node

#tab1
export (NodePath) onready var tabContainer = get_node(tabContainer) as TabContainer
export (NodePath) onready var Hide_table_button = get_node(Hide_table_button) as CheckButton
export (NodePath) onready var ddi = get_node(ddi) as SpinBox
export (NodePath) onready var WW_glucose_box = get_node(WW_glucose_box) as VBoxContainer
export (NodePath) onready var Values_label = get_node(Values_label) as RichTextLabel
export (NodePath) onready var WW_morning_cell = get_node(WW_morning_cell) as RichTextLabel
export (NodePath) onready var Glucose_morning_cell = get_node(Glucose_morning_cell) as RichTextLabel
export (NodePath) onready var WW_afternoon_cell = get_node(WW_afternoon_cell) as RichTextLabel
export (NodePath) onready var Glucose_afternoon_cell = get_node(Glucose_afternoon_cell) as RichTextLabel
export (NodePath) onready var WW_evening_cell = get_node(WW_evening_cell) as RichTextLabel
export (NodePath) onready var Glucose_evening_cell = get_node(Glucose_evening_cell) as RichTextLabel
export (NodePath) onready var calculate_meal = get_node(calculate_meal) as Control

#tab2
export (NodePath) onready var enteredDDI = get_node(enteredDDI) as RichTextLabel
export (NodePath) onready var Static1_Box = get_node(Static1_Box) as VBoxContainer
export (NodePath) onready var WW_insuline_label = get_node(WW_insuline_label) as RichTextLabel
export (NodePath) onready var Math = get_node(Math) as RichTextLabel
export (NodePath) onready var Day_time_calculations = get_node(Day_time_calculations) as RichTextLabel
export (NodePath) onready var Static2_Box = get_node(Static2_Box) as VBoxContainer
export (NodePath) onready var Math2 = get_node(Math2) as RichTextLabel
export (NodePath) onready var JI_glucose_label = get_node(JI_glucose_label) as RichTextLabel


export (int) var ddi_value = 45
export (int) var static_1 = 450
export (int) var static_2 = 1500


func _ready():
	ddi.get_line_edit().grab_focus()
	print("----------------------")
	print("----------------------")
	print("----------------------")
	print("Przelicznik WW")
	tabContainer.set_tab_disabled(1, true)


func calculate_Insuline_and_WW():
	ddi_value = ddi.value
	var i_1W = stepify((static_1/ddi_value), 0.00000001)
	var i_1WW  = stepify(i_1W/10,0.01)
	var WW_1i : float = stepify(1/i_1WW,0.00000001)
	var WW_morning : float = stepify(WW_1i*1.5,0.01)
	var WW_afternoon : float = stepify(WW_1i,0.01)
	var WW_evening : float = stepify(WW_1i*1.3,0.01)
	var JI_glucose_result = stepify(static_2/ddi_value,0.00000001)
	var JI_morning = stepify(JI_glucose_result/1.5,0.01)
	var JI_afternoon = stepify(JI_glucose_result,0.01)
	var JI_evening = stepify(JI_glucose_result/1.3,0.01)
	#tab2
	var i_1WW_text = "%s : %s = %s \n1 jednostka insuliny zbija %s Węglowodanów "
	
	#tab1
	Values_label.bbcode_text = "[b][u]%s WW[/u][/b] <-- tyle zbija 1 JI" %i_1WW
	Values_label.bbcode_text += "\n[b][u]%s[/u][/b] <-- tyle JI należy podać na 1 WW" %[WW_1i]
	Values_label.bbcode_text += "\n[b][u]%s[/u][/b] <-- tyle cukru zbija 1 JI" %[JI_glucose_result]
	Values_label.bbcode_text += "\n(wartości w przybliżeniu przy zerowej oporności)"
	WW_morning_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_morning
	WW_afternoon_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_afternoon
	WW_evening_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %WW_evening
	Glucose_morning_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %JI_morning
	Glucose_afternoon_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %JI_afternoon
	Glucose_evening_cell.bbcode_text = "[color=#ef8522][b][i][center]%s[/center][/i][/b][/color]" %JI_evening
	
	#tab2
	enteredDDI.bbcode_text = "Twoje DDI: [color=#ef8522][b]%s[/b][/color]" %ddi_value
	WW_insuline_label.bbcode_text = i_1WW_text % [str(static_1),str(ddi_value),str(i_1W), str(i_1W)]
	WW_insuline_label.bbcode_text += "czyli około: [b][u]%s WW[/u][/b]" %i_1WW
	Math.bbcode_text = "Następnie obliczamy z proporcji: \n1j --> %s WW \nx -> 1 WW" %i_1WW
	Math.bbcode_text += "\nx = (1WW * 1j) / %s = [b][u]%s[/u][/b] <-- tyle jednostek insuliny należy podać na 1WW" %[i_1WW, WW_1i]
	Day_time_calculations.bbcode_text = "[b]Rano[/b] jest największa oporność, należy podać 50% więcej JI:\n" 
	Day_time_calculations.bbcode_text+= "[b]%s[/b] * 1.5 = [color=#ef8522][b][u]%s[/u][/b][/color] JI na 1 WW" %[str(WW_1i), str(WW_morning)]
	Day_time_calculations.bbcode_text+= "\n[b]Popołudniu[/b] jest standardowa oporność:\n" 
	Day_time_calculations.bbcode_text+= "[color=#ef8522][b][u]%s[/u][/b][/color] JI na 1 WW" %[str(WW_afternoon)]
	Day_time_calculations.bbcode_text+= "\n[b]Wieczorem[/b]jest podwyższona oporność, należy podać 30% więcej JI:\n" 
	Day_time_calculations.bbcode_text+= "[b]%s[/b] * 1.3 = [color=#ef8522][b][u]%s[/u][/b][/color] JI na 1 WW" %[str(WW_1i), str(WW_evening)]
	Math2.bbcode_text = "%s/%s = [b][u]%s[/u][/b]  <--  tyle cukru zbija 1JI" %[static_2, ddi_value, JI_glucose_result]
	JI_glucose_label.bbcode_text = "[b][u][i]%s[/i][/u][/b] <--  w przybliżeniu tyle cukru zbija 1JI" %[JI_glucose_result]
	JI_glucose_label.bbcode_text+= "\n[b]Rano[/b] zbija o 50% mniej: "
	JI_glucose_label.bbcode_text+= "%s/1.5 = [color=#ef8522][b]%s[/b][/color]" %[JI_glucose_result, JI_morning]
	JI_glucose_label.bbcode_text+= "\n[b]Popołudniu[/b]  normalnie: [color=#ef8522][b]%s[/b][/color]" %JI_afternoon
	JI_glucose_label.bbcode_text+= "\n[b]Wieczorem[/b] 30% mniej: "
	JI_glucose_label.bbcode_text+= "%s/1.3 = [color=#ef8522][b]%s[/b][/color]" %[JI_glucose_result,JI_evening]
	
	
func _on_CalculateButton_pressed():
	calculate_Insuline_and_WW()
	tabContainer.set_tab_disabled(1, false)
	calculate_meal.visible = true
	calculate_meal.recalc()
	Hide_table_button.pressed = true


func _on_Hide_table_button_toggled(button_pressed):
	if button_pressed:
		WW_glucose_box.visible = true
	else:
		WW_glucose_box.visible = false


func _on_Hide_tab2_1_button_toggled(button_pressed):
	if button_pressed:
		Static1_Box.visible = true
	else:
		Static1_Box.visible = false


func _on_Hide_tab2_2_button_toggled(button_pressed):
	if button_pressed:
		Static2_Box.visible = true
	else:
		Static2_Box.visible = false
