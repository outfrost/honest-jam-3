extends RichTextLabel

signal fully_displayed()

export(float, 0.0, 5.0) var display_delay: float
export(float, 0.0, 5.0) var mangle_step: float
export(float, 0.0, 5.0) var mangling_stop_delay: float
export var mangling_chance: Curve

onready var font_regular: Font = get_font("normal_font")

var words_by_width: Dictionary = {}
var sentence_text: String = ""
var time_elapsed: float = 0.0
var times_mangled: int = 0
var words_shown: int = 0
var fully_displayed: bool = true
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	mangling_chance.bake()

func _process(delta: float) -> void:
	if fully_displayed:
		return

	time_elapsed += delta
	if time_elapsed < display_delay:
		return

	if time_elapsed < display_delay + mangling_stop_delay:
		if time_elapsed < display_delay + times_mangled * mangle_step:
			return

		var progress: float = inverse_lerp(
			display_delay,
			display_delay + mangling_stop_delay,
			time_elapsed)
		var chance: float = mangling_chance.interpolate_baked(progress)

		var text = get_mangled_sentence(sentence_text, chance)
		var words = text.split(" ", false)
		words_shown = min(
			max(words_shown + 1, (words.size() as float * progress) as int),
			words.size())
		bbcode_text = "\t"
		for i in range(words_shown):
			if i > 0:
				bbcode_text += " "
			bbcode_text += words[i]
		times_mangled += 1
	else:
		bbcode_text = "\t" + sentence_text
		emit_signal("fully_displayed")
		fully_displayed = true

func calc_word_widths(library: Dictionary) -> void:
	for key in library:
		var text = library[key].text
		var words = text.split(" ", false)
		for word in words:
			var width: int = get_word_width(word)
			var arr = words_by_width.get(width, [])
			if !arr.has(word):
				arr.append(word)
			words_by_width[width] = arr
	print(words_by_width)

func display(text: String) -> void:
	time_elapsed = 0.0
	times_mangled = 0
	words_shown = 0
	fully_displayed = false
	sentence_text = text
	bbcode_text = ""

func get_mangled_sentence(s: String, chance: float) -> String:
	var result = ""
	var words = s.split(" ", false)
	for word in words:
		var width: int = get_word_width(word)
		var replacements: Array = words_by_width.get(width, [])
		if !result.empty():
			result += " "
		if replacements.empty():
			result += word
		else:
			var mangle = rng.randf_range(0.0, 1.0)
			if mangle < chance:
				result += replacements[rng.randi_range(0, replacements.size() - 1)]
			else:
				result += word
	return result

func get_word_width(w: String) -> int:
	var width: int = font_regular.get_string_size(w).x as int
	width -= width % 5
	return width
