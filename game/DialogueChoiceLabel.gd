extends RichTextLabel

signal accepted()

func _ready() -> void:
	connect("mouse_entered", self, "grab_focus")
	connect("focus_entered", self, "on_focus_entered")
	connect("focus_exited", self, "on_focus_exited")

func on_focus_entered() -> void:
	set("custom_colors/default_color", Color("#e65c17"))

func on_focus_exited() -> void:
	set("custom_colors/default_color", null)

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("accepted")
