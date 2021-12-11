extends RichTextLabel

export(float, 0.0, 5.0) var DISPLAY_DELAY: float

onready var font_regular: Font = get_font("normal_font")

var words_by_width: Dictionary = {}
var sentence_text: String = ""
var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed < DISPLAY_DELAY:
		return

	bbcode_text = sentence_text

func calc_word_widths() -> void:
#	var sentence: Sentence = get_sentence("start")
	var words = sentence.text.split(" ", false)
	for word in words:
		var width: int = sentence_font_regular.get_string_size(word).x as int
		var arr = sentence_label.words_by_width.get(width, [])
		arr.append(word)
		sentence_label.words_by_width[width] = arr
	print(sentence_label.words_by_width)

func display(text: String) -> void:
	time_elapsed = 0.0
	sentence_text = text
	bbcode_text = ""

func get_mangled_sentence(s: String) -> String:
	return ""
