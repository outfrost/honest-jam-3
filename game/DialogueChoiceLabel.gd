extends RichTextLabel

signal accepted()

export var default_color: Color
export var focused_color: Color

func _ready() -> void:
	set("custom_colors/default_color", default_color)
	connect("mouse_entered", self, "grab_focus")
	connect("focus_entered", self, "on_focus_entered")
	connect("focus_exited", self, "on_focus_exited")

func on_focus_entered() -> void:
	set("custom_colors/default_color", focused_color)

func on_focus_exited() -> void:
	set("custom_colors/default_color", default_color)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("accepted")
