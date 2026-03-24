import luaparser.astnodes as astNode
from luaparser import ast, utils
import pickle
import os

def load_ggl_groups():
     # Parse the Lua file to an AST
    with open("./Templates/Groups.lua", 'r') as f:
        groupTree = ast.parse(f.read())

    for node in ast.walk(groupTree):
        if isinstance(node, ast.Assign) and node.targets[0].id == 'Groups':
            values = node.values[0]
            return node.values[0]

def check_pickle_cache():
    try:
        with open('./cache/GroupCache.pickle', 'rb') as f:
            return pickle.load(f)
    except:
        return None

GroupCache = None

def ggl_group():
    global GroupCache
    if GroupCache is not None:
        return GroupCache

    pickle_cache = check_pickle_cache()

    if pickle_cache is not None:
        GroupCache = pickle_cache
        return GroupCache

    GroupCache = load_ggl_groups()
    os.makedirs("cache", exist_ok=True)
    with open('./cache/GroupCache.pickle', 'wb+') as f:
        pickle.dump(GroupCache, f)

    return GroupCache

if __name__ == "__main__":
    print("Building the GGL group cache.")
    
    cache = load_ggl_groups()
    os.makedirs("cache", exist_ok=True)
    with open('./cache/GroupCache.pickle', 'wb+') as f:
        pickle.dump(cache, f)
