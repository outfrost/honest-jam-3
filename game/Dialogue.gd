class_name Dialogue
extends Control

class Sentence:
	var text: String
	var choices: Array

	func _init(text: String):
		self.text = text

	func next(n: String) -> Sentence:
		choices.append(Choice.new("", "", n))
		return self

	func choice(text: String, next: String) -> Sentence:
		choices.append(Choice.new(text, "", next))
		return self

	func action(text: String, action: String, next: String = "") -> Sentence:
		choices.append(Choice.new(text, action, next))
		return self

	func fmt() -> String:
		var choices_fmt: String = "["
		if choices.size() > 0:
			choices_fmt += "\n"
		for choice in choices:
			choices_fmt += "\t" + choice.fmt() + "\n"
		choices_fmt += "]"
		return "{ \"%s\", %s }" % [text, choices_fmt]

class Choice:
	var text: String
	var action: String
	var next: String

	func _init(text: String, action: String, next: String):
		self.text = text
		self.action = action
		self.next = next

	func fmt() -> String:
		return "{ \"%s\", action: \"%s\", next: \"%s\" }" % [text, action, next]

var library: Dictionary = {
	"start": Sentence.new("Hey there!").choice("Hi", "start").choice("Hello", "foo")
}

export var choice_label_scene: PackedScene

onready var sentence_label: RichTextLabel = $SentenceLabel
onready var choices_container = $ChoicesContainer

func _ready() -> void:
	reset()

func start() -> void:
	display_sentence(get_sentence("start"))

func reset() -> void:
	for child in choices_container.get_children():
		choices_container.remove_child(child)
		child.queue_free()

	sentence_label.bbcode_text = ""

func display_sentence(s: Sentence) -> void:
	for child in choices_container.get_children():
		choices_container.remove_child(child)
		child.queue_free()

	sentence_label.bbcode_text = "\t" + s.text

	var first_choice: bool = true
	for choice in s.choices:
		var label: RichTextLabel = choice_label_scene.instance()
		label.bbcode_text = "[center]%s[/center]" % choice.text
		choices_container.add_child(label)
		label.connect("accepted", self, "on_choice_accepted", [choice])
		if first_choice:
			label.grab_focus()
			first_choice = false

func on_choice_accepted(c: Choice) -> void:
	if !c.action.empty():
		if has_method(c.action):
			call(c.action)
		else:
			push_error("No method for action \"%s\"" % c.action)
			display_sentence(Sentence.new("Oh no, we've glitched!").action("Whoops", "quit"))
	else:
		display_sentence(get_sentence(c.next))

func get_sentence(key: String) -> Sentence:
	return library.get(
		key,
		Sentence.new("Oh no, we've glitched!").action("Whoops", "quit")
	)

# Actions

func quit() -> void:
	find_parent("Game").back_to_menu()
