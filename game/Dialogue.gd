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
	"start": Sentence.new("Hey there!").choice("Hi", "test1").choice("Hello", "foo"),
	"test1": Sentence.new("Why are you doing what you are doing?").next("test2"),
	"test2": Sentence.new("The quick brown fox jumped over the lazy pigeon.").next("test3"),
	"test3": Sentence.new("Sphinx of black quartz, hear my vow!").next("test4"),
	"test4": Sentence.new("Lynxes are really cute.").next("test5"),
	"test5": Sentence.new("Savior stands atop the mountain and screams into the void.").next("bar"),
}

export var choice_label_scene: PackedScene

onready var sentence_label: RichTextLabel = $SentenceLabel
onready var choices_container = $ChoicesContainer

func _ready() -> void:
	reset()
	sentence_label.calc_word_widths(library)
	sentence_label.connect("fully_displayed", self, "on_sentence_displayed")

func start() -> void:
	display_sentence(get_sentence("start"))

func reset() -> void:
	for child in choices_container.get_children():
		choices_container.remove_child(child)
		child.queue_free()

	sentence_label.display("")

func display_sentence(s: Sentence) -> void:
	for child in choices_container.get_children():
		choices_container.remove_child(child)
		child.queue_free()
	choices_container.hide()

	sentence_label.display(s.text)

	for choice in s.choices:
		var label: RichTextLabel = choice_label_scene.instance()
		label.bbcode_text = "[center]%s[/center]" % choice.text
		choices_container.add_child(label)
		label.connect("accepted", self, "on_choice_accepted", [choice])

func on_sentence_displayed() -> void:
	choices_container.show()
	if choices_container.get_child_count() > 0:
		choices_container.get_child(0).grab_focus()

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
