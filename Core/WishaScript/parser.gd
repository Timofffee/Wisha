extends Reference
class_name WishaScriptParser

var wst: WishaScriptTokenizer
var token = WishaScriptTokenizer.Token

func _init() -> void:
    wst = WishaScriptTokenizer.new()

func parse_script(path: String = "<none>") -> Array:
    var scenario: Array = []
    var file = File.new();
    if (file.open(path, File.READ) != OK):
        print("Can't open the file: " + path)
        return []
    # var index = 1
    while not file.eof_reached(): 
        var line = file.get_line()
        line = line.strip_edges()
        if line.empty():
            continue
        # print(str(index) + " " + line)
        scenario.append(wst.get_token(line))
        # index += 1
    file.close() 
        
    scenario = preprocess(scenario)

    return scenario

func preprocess(scenario: Array) -> Array:
    var complete_scenario: Array = []
    for idx in scenario.size():
        match scenario[idx]["type"]:
            token.TEXT_PLUS:
                if complete_scenario.back()["type"] in \
                        [
                            token.TEXT_ADD, token.TEXT_DIRECT, 
                            token.TEXT_SIMPLE, token.TEXT_THOUGTH
                        ] and not complete_scenario.empty():
                    complete_scenario.back()["text"] += "\n" + scenario[idx]["text"]
                else:
                    print("WARNING!! Incorrect token position!\nLine: " + scenario[idx])
            token.LABEL:
                continue
            _:
                complete_scenario.append(scenario[idx])

    return complete_scenario
