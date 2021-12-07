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

var LIBRARY: Dictionary = {
	"start": Sentence.new("Hey there!").next("start")
}

func _ready() -> void:
	var sentence = get_sentence("foo")
	print(sentence.fmt())

func get_sentence(key: String) -> Sentence:
	return LIBRARY.get(
		key,
		Sentence.new("Oh no, we've glitched!").action("", "quit")
	)
