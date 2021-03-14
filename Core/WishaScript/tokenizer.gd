extends Reference
class_name WishaScriptTokenizer

enum Token {
	LABEL = 1,
	BACKGROUD = 2,
	MUSIC = 3,

	ENV = 10,
	FADE_IN = 20,
	FADE_OUT = 21,

	TEXT_SIMPLE = 100,
	TEXT_DIRECT = 101,
	TEXT_THOUGTH = 102,
	TEXT_ADD = 103,
	TEXT_PLUS = 104
}

var base_tokens = {
	"label" : funcref(self, "TOKEN_LABEL"),
	"bg" : funcref(self, "TOKEN_BACKGROUD"),
	"music" : funcref(self, "TOKEN_MUSIC"),

	"env" : funcref(self, "TOKEN_ENV"),
	"fade_in" : funcref(self, "TOKEN_FADE_IN"),
	"fade_out" : funcref(self, "TOKEN_FADE_OUT"),

	"-" : funcref(self, "TOKEN_TEXT_SIMPLE"),
	# ">" : funcref(self, "TOKEN_TEXT_DIRECT"),
	"~" : funcref(self, "TOKEN_TEXT_THOUGTH"),
	"\\" : funcref(self, "TOKEN_TEXT_ADD"),
	"+" : funcref(self, "TOKEN_TEXT_PLUS")
}

#TEMPORARY
var characters = {
	"Wheel" : {
		"alias" : "w"
	}
}

func TOKEN_LABEL(line: String) -> Dictionary:
	return {"type" : Token.LABEL, "name" : line}

func TOKEN_BACKGROUND(line: String) -> Dictionary:
	return {"type" : Token.BACKGROUD, "path" : line}

func TOKEN_MUSIC(line: String) -> Dictionary:
	return {"type" : Token.MUSIC, "path" : line}

func TOKEN_ENV(line: String) -> Dictionary:
	return {"type" : Token.ENV, "name" : line}

func TOKEN_FANE_IN(line: String) -> Dictionary:
	return {"type" : Token.FADE_IN, "name" : line}

func TOKEN_FADE_OUT(line: String) -> Dictionary:
	return {"type" : Token.FADE_OUT, "name" : line}

func TOKEN_TEXT_SIMPLE(line: String) -> Dictionary:
	return {"type": Token.TEXT_SIMPLE, "text" : line}

func TOKEN_TEXT_THOUGTH(line: String) -> Dictionary:
	return {"type": Token.TEXT_THOUGTH, "text" : line}

func TOKEN_TEXT_ADD(line: String) -> Dictionary:
	return {"type": Token.TEXT_ADD, "text" : line}

func TOKEN_TEXT_PLUS(line: String) -> Dictionary:
	return {"type": Token.TEXT_PLUS, "text" : line}

func TOKEN_TEXT_DIRECT(who: String, text: String) -> Dictionary:
	return {"type": Token.TEXT_DIRECT, "who" : who, "text" : text}


func get_token(line: String) -> Dictionary:
	var l = line.split(" ", true, 1)
	for pattern in base_tokens:
		if (l[0] == pattern):
			var token = (base_tokens[pattern] as FuncRef).call_funcv([l[1]])
			if typeof(token) != TYPE_DICTIONARY:
				print("WARNING!! Can't find token \"" + pattern + "\"") 
				return {}
			return (base_tokens[pattern] as FuncRef).call_funcv([l[1]]) as Dictionary
	
	for who in characters:
		if (l[0] == who or l[0] == characters[who]["alias"]):
			return TOKEN_TEXT_DIRECT(who, l[1])


	return {}
