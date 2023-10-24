extends VBoxContainer

@onready var message_list = %MessageList
@onready var message_input = %MessageInput
@onready var message_scroll = %MessageScroll

# Called when the node enters the scene tree for the first time.
func _ready():
	ChatService.message_received.connect(_on_message_received)


func _create_new_message(author: String, message: String):
	var message_label = RichTextLabel.new()
	message_label.bbcode_enabled = true
	message_label.fit_content = true
	message_label.text = "[color=#FF0000]%s[/color]: %s" % [author, message]
	message_list.add_child(message_label)


func _on_message_received(player_id: int, message: String):
	var player_name = MultiplayerManager.players[player_id].name
	_create_new_message(player_name, message)
	await get_tree().process_frame
	message_scroll.scroll_vertical = message_scroll.get_v_scroll_bar().max_value


func _on_send_pressed():
	if message_input.text.is_empty():
		return
	ChatService.send_message.rpc(message_input.text)
	message_input.text = ""
