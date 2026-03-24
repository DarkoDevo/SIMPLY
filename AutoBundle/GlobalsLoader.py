import luaparser.astnodes as astNode
from luaparser import ast
from ProfileBuilder import build_all_code_snippets
import json

GlobalsConfig = None

def get_globals_config():
    global GlobalsConfig
    if GlobalsConfig is not None:
        return GlobalsConfig

    with open("./Globals.json", 'r') as f:
        GlobalsConfig = json.loads(f.read())

    return GlobalsConfig

def load_global_file():
    global_json = get_globals_config()

    code_snippets = build_all_code_snippets(global_json)

    code_snippet_table = astNode.Table(fields=code_snippets)
    return astNode.Field(key=astNode.String(s="CodeSnippets"), value=code_snippet_table, between_brackets=True)

LoadedGlobals = None

def get_globals():
    global LoadedGlobals
    if LoadedGlobals is not None:
        return LoadedGlobals

    LoadedGlobals = load_global_file()
    return LoadedGlobals