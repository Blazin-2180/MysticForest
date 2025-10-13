@tool 
#@icon()
class_name NPC extends CharacterBody2D

signal behaviour_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"
var do_behaviour : bool = true

@export var npc_resource : NPCResource : set = _set_npc_resource

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	setup_npc()
	if Engine.is_editor_hint():
		return
	behaviour_enabled.emit()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass

func update_animation() -> void :
	animation_player.play( state + "_" + direction_name )

func update_direction( target_position : Vector2 ) -> void :
	direction = global_position.direction_to( target_position )
	update_direction_name()
	#Make the sprite update depending on which direction they are facing.
	if direction_name == "side" && direction.x < 0 :
		sprite.flip_h = true
	else : 
		sprite.flip_h = false

func update_direction_name() -> void :
	var threshhold : float = 0.45
	if direction.y < -threshhold :
		direction_name = "up"
	elif direction.y > threshhold :
		direction_name = "down"
	elif direction.x > threshhold || direction.x < -threshhold :
		direction_name = "side"

func setup_npc() -> void :
	if npc_resource :
		if sprite :
			sprite.texture = npc_resource.sprite
	pass

func _set_npc_resource( _npc : NPCResource) -> void :
	npc_resource = _npc
	setup_npc()
	pass
