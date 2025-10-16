@tool
#@icon()
class_name DialogInteraction extends Area2D

#region /// SIGNALS
signal player_interacted 
signal finished
#endregion

#region /// EXPORT VARIABLES
@export var enabled : bool = true
#endregion

#region /// STANDARD VARIABLES
var dialog_items : Array[ DialogItem ]
#endregion

#region /// ON READY VARIABLES
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#endregion

func _ready() -> void:
	if Engine.is_editor_hint() :
		return
	
	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited )
	
	for c in get_children() :
		if c is DialogItem :
			dialog_items.append( c )
			
func player_interact() -> void :
	player_interacted.emit()
	await get_tree().create_timer(0.2).timeout
	DialogSystem.show_dialog( dialog_items)
	DialogSystem.finished.connect( _on_dialog_finished )
	pass

func _on_area_entered( _a : Area2D) -> void :
	if enabled == false || dialog_items.size() == 0:
		return
	animation_player.play( "show" )
	GlobalPlayerManager.interact_pressed.connect( player_interact)
	pass

func _on_area_exited( _a : Area2D) -> void :
	animation_player.play( "hide" )
	GlobalPlayerManager.interact_pressed.disconnect( player_interact)
	pass

func _get_configuration_warnings() -> PackedStringArray :
	#check for dialog items
	if _check_for_dialog_items() == false :
		return ["Requires at least one dialog item node"]
	else : 
		return[]


func _check_for_dialog_items() -> bool :
	for c in get_children() :
		if c is DialogItem :
			return true
	return false

func _on_dialog_finished() -> void :
	DialogSystem.finished.disconnect( _on_dialog_finished )
	finished.emit()
