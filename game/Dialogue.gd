class_name Dialogue
extends Control

class Sentence:
	var text: String
	var choices: Array

	func _init(text: String):
		self.text = text

	func next(n: String) -> Sentence:
		choices.append(Choice.new("[ ... ]", "", n))
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
	"test1": Sentence.new("Why are you doing what you are doing?").next("test2"),
	"test2": Sentence.new("The quick brown fox jumped over the lazy pigeon.").next("test3"),
	"test3": Sentence.new("Sphinx of black quartz, hear my vow!").next("test4"),
	"test4": Sentence.new("Lynxes are really cute.").next("test5"),
	"test5": Sentence.new("Savior stands atop the mountain and screams into the void.").next("bar"),

	"start": Sentence.new(
		"06:41.").next("start2"),
	"start2": Sentence.new(
		"You step outside your apartment block."
		+ " The stupid front door won't shut on its own again.") \
		.choice("[ Ignore it ]", "start3") \
		.choice("[ Push it shut ]", "start3"),
	"start3": Sentence.new(
		"It's chilly, and raining. You pull the hood of your jacket on,"
		+ " and start heading to the train station at a brisk pace.").next("broken_car"),

	"broken_car": Sentence.new(
		"You pass by your car, still broken down.").next("broken_car_2"),
	"broken_car_2": Sentence.new(
		"You don't need it today, but the pain of maintaining it"
		+ " still haunts you all the time.").next("hungry"),

	"hungry": Sentence.new(
		"You feel hungry.").next("store"),
	"store": Sentence.new(
		"Around the corner, you enter a convenience store, in hope of finding"
		+ " a quick snack.").next("long_grass"),
	"long_grass": Sentence.new(
		"There are a dozen people standing in long grass,"
		+ " next to one another, and maybe up to 100 more further down the aisle.").next("store_neighbour"),
	"store_neighbour": Sentence.new(
		"You recognise your neighbour, Anton, as he says \"good morning\".").next("russian_doggo"),
	"russian_doggo": Sentence.new(
		"He has a dog who looks like a beagle or pug. His name is Oleg,"
		+ " which Anton says is short for Russian Eagle.").next("store_neighbour_2"),
	"store_neighbour_2": Sentence.new(
		"\"Wanna stay for a bit and chat with my friends here?\", Anton asks.") \
		.choice("\"Sure!\"", "join_circle") \
		.choice("\"No, thank you, I'm in a bit of a hurry.\"", "store_pay"),

	"store_pay": Sentence.new(
		"You grab a panini sandwich from the shelf, and turn around to pay.").next("store_pay_2"),
	"store_pay_2": Sentence.new(
		"The cashier scans your item. £4.90.") \
		.choice("[ Pay with card ]", "store_pay_3") \
		.choice("[ Pay with cash ]", "store_pay_3"),
	"store_pay_3": Sentence.new(
		"You pay, grab your panini, and leave.").next("street_1"),

	"street_1": Sentence.new(
		"Streetlights are just about flickering off as the sky gets brighter.").next("street_2"),
	"street_2": Sentence.new(
		"Not too bright; it's still raining.").next("street_3"),
	"street_3": Sentence.new(
		"You look behind and see a bus approaching.") \
		.choice("[ Get on the bus ]", "bus_1") \
		.choice("[ Keep walking ]", "street_4"),
	"street_4": Sentence.new(
		"The bus picks up some passengers at the stop, and drives off into the rain.").next("street_5"),
	"street_5": Sentence.new(
		"Urban activity is picking up pace. More people on the street,"
		+ " more bikes and cars zooming past.").next("park_1"),

	"join_circle": Sentence.new(
		"You take off your raincoat and join the circle.").next("store_convo"),
	"store_convo": Sentence.new(
		"Anton gets the others' attention and says a few words about you.").next("store_convo_2"),
	"store_convo_2": Sentence.new(
		"Your eyes are drawn to one particular person, seemingly for no reason"
		+ " - an average-postured young woman with shoulder-length black hair.").next("store_convo_3"),
	"store_convo_3": Sentence.new(
		"She looks back at you, briefly, with an empty, emotionless stare."
		+ " Others keep talking, but your mind has drifted from the topic.").next("store_convo_4"),
	"store_convo_4": Sentence.new(
		"You open the panini sandwich and take a bite.").next("store_convo_5"),
	"store_convo_5": Sentence.new(
		"The group walks out onto the street, and you follow.").next("park_group_1"),

	"park_1": Sentence.new(
		"You cross the road and enter a park. The train station is down this hill"
		+ " and around the duck pond.").next("park_2"),
	"park_2": Sentence.new(
		"A flight of stairs down from the gate, you notice a group of college students"
		+ " sat on a bench, playing a video game projected onto a stone wall"
		+ " across the path.").next("park_3"),
	"park_3": Sentence.new(
		"Standing behind them and watching the game is an average-postured young woman"
		+ " with shoulder-length black hair.").next("park_4"),

	"park_group_1": Sentence.new(
		"You cross the road and enter a park. The train station is down this hill"
		+ " and around the duck pond.").next("park_group_2"),
	"park_group_2": Sentence.new(
		"A flight of stairs down from the gate, you notice a group of college students"
		+ " sat on a bench, playing a video game projected onto a stone wall"
		+ " across the path.").next("park_group_3"),
	"park_group_3": Sentence.new(
		"Standing behind them and watching the game is the same girl you saw at the store.").next("park_4"),

	"park_4": Sentence.new(
		"You walk up to her. Her dog turns towards you, excited and happy, wagging their tail.") \
		.choice("[ Pet the dog ]", "park_5") \
		.choice("[ Pet the dog ]", "park_5") \
		.choice("[ Pet the dog ]", "park_5"),

	"park_5": Sentence.new(
		"The dog takes a playful stance. It seems like they want to race you to the the pond.").next("park_6"),
	"park_6": Sentence.new(
		"You both start running. For a moment, you can keep up with the dog's pace,"
		+ " but soon enough they get faster and run ahead of you.").next("park_7"),
	"park_7": Sentence.new(
		"Before you realise it, you're running straight into the pond.").next("park_8"),
	"park_8": Sentence.new(
		"You jump to avoid the short fence in front.").next("park_9"),
	"park_9": Sentence.new(
		"Just as you're about to hit the water, you look to the side, at the dog, staring at you"
		+ " visibly confused.").next("park_10"),
	"park_10": Sentence.new(
		"Then everything disappears into darkness.").next("facility_1"),

	"bus_1": Sentence.new(
		"You take a seat on the bus as it departs.").next("bus_2"),
	"bus_2": Sentence.new(
		"As it gets closer to the intersection ahead, you hear the bus driver put on the blinker."
		+ " You realise the bus isn't going to the train station.").next("bus_3"),
	"bus_3": Sentence.new(
		"A couple of turns, and the bus gets away from all the morning rush."
		+ " You're now going through what looks like a rather depressing"
		+ " industrial complex.").next("bus_4"),
	"bus_4": Sentence.new(
		"Finally, the bus makes a stop, and you rush to get off quickly.").next("bus_5"),
	"bus_5": Sentence.new(
		"You hop out the door...").next("bus_6"),
	"bus_6": Sentence.new(
		"... but just as you're meant to touch down on the sidewalk, you fall through,"
		+ " and everything dissolves into darkness.").next("facility_1"),

	"facility_1": Sentence.new(
		"... ... ...").next("facility_1a"),
	"facility_1a": Sentence.new(
		"You're standing in a dimly lit corridor, with shiny metal walls.").next("facility_2"),
	"facility_2": Sentence.new(
		"It looks like a poorly maintained warehouse of some kind. Or manufacturing plant?").next("facility_3"),
	"facility_3": Sentence.new(
		"Creepy-looking vines and roots hang onto some iron beams overhead.").next("facility_4"),
	"facility_4": Sentence.new(
		"<< \"Oh, hey there.\" >>, says a loud voice,"
		+ " coming from nowhere in particular.").next("facility_5"),
	"facility_5": Sentence.new(
		"<< \"Are you lost?\" >>").next("tbc"),

	"tbc": Sentence.new(
		"[ To be continued ]").action("[ End ]", "quit"),

#	"": Sentence.new("").next(""),
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
