extends Control

var menu_origin_pos = Vector2.ZERO
var menu_origin_size = Vector2.ZERO

var transition_time = 0.3
var current_menu
var menu_stack = []
var show_credits = false

onready var main_menu = $MainMenu
onready var question_menu = $QuestionMenu
onready var tween = $Tween
onready var creditpopup = $MainMenu/Popup

func _ready():
	menu_origin_pos = Vector2.ZERO
	menu_origin_size = get_viewport_rect().size
	current_menu = main_menu


func next_menu(next_id: String):
	var next_menu = get_menu(next_id)
	tween.interpolate_property(current_menu, "rect_global_position", current_menu.rect_global_position, Vector2(-menu_origin_size.x, 0), transition_time)
	tween.interpolate_property(next_menu, "rect_global_position", next_menu.rect_global_position, menu_origin_pos, transition_time)
	tween.start()
	menu_stack.append(current_menu)
	current_menu = next_menu


func previous_menu():
	var prev = menu_stack.pop_back()
	if prev != null:
		tween.interpolate_property(current_menu, "rect_global_position", current_menu.rect_global_position, Vector2(menu_origin_size.x, 0), transition_time)
		tween.interpolate_property(prev, "rect_global_position", prev.rect_global_position, menu_origin_pos, transition_time)
		tween.start()
		current_menu = prev


func get_menu(menu_id: String) -> Control:
	match menu_id:
		"main":
			return main_menu
		"question":
			return question_menu
		_:
			return main_menu


func _on_Button_pressed():
	next_menu("question")


func _on_BackButton_pressed():
	previous_menu()


func _on_CreditsButton_pressed():
	if(!show_credits):
		creditpopup.popup()
		show_credits = true
	else:
		creditpopup.hide()
		show_credits = false


func _on_ExitButton_pressed():
	get_tree().quit()
