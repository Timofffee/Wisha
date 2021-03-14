extends Node
class_name Game

var scenario
var current_token: int = -1
var token = WishaScriptTokenizer.Token

func _ready() -> void:
    var wsp = WishaScriptParser.new()
    scenario = wsp.parse_script("res://Content/Scenarios/Act1.ws")
    next_token()

        
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        next_token()
    elif event is InputEventKey and (event as InputEventKey).scancode == KEY_SPACE and event.is_pressed():
        next_token()
    
func next_token() -> void:
    if current_token + 1 == scenario.size():
        return
    current_token += 1
    
    var ct = scenario[current_token]

    match ct["type"]:
        token.TITLE:
            clear()
            $"title".text = ct["name"]
        token.ENV:
            clear()
            $"env".text = "[EVIROVMENT]\n~" + ct["name"] + "~"
        token.HIDE:
            if ct["name"] == "story":
                $"story".hide()
                next_token()
        token.TEXT_SIMPLE:
            clear()
            if (not $"story".visible):
                $"story".show()
            $"story/Text".text = ct["text"]
        token.TEXT_DIRECT:
            clear()
            if (not $"story".visible):
                $"story".show()
            $"story/Who".text = ct["who"]
            $"story/Text".text = ct["text"]
        token.TEXT_THOUGTH:
            clear()
            if (not $"story".visible):
                $"story".show()
            $"story/Who".text = "~"
            $"story/Text".text = ct["text"]
        token.TEXT_ADD:
            $"story/Text".text += "\n" + ct["text"]
        _:
            next_token()
                
func clear() -> void:
    $"title".text = ""
    $"story/Text".text = ""
    $"story/Who".text = ""
        
