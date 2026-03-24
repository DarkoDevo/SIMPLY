import luaparser.astnodes as astNode
from luaparser import ast, utils
from GGLGroups import ggl_group
from ConfigLoaders import load_profiles_dict, load_exports_dict
from ProfileBuilder import build_all_profiles_for_export
from GlobalsLoader import get_globals, get_globals_config
from CustomLuaPrinter import MakuluLuaPrinter
from multiprocessing import Pool, cpu_count
from more_itertools import divide

import time
import os
import argparse
import subprocess

file_name = './Templates/BaseTMW.lua'

def modify_lua_ast(export_json, profile_jsons):
    # Parse the Lua file to an AST
    with open(file_name, 'r') as f:
        tree = ast.parse(f.read())

    # Traverse the AST to find the target subtable
    main_table = None
    global_table = None

    for node in ast.walk(tree):
        if isinstance(node, ast.Assign) and node.targets[0].id == 'TellMeWhenDB':
            main_table = node.values[0]

        if isinstance(node, ast.Field) and isinstance(node.key, ast.String) and node.key.s == 'global':
            global_table = node.value

        if main_table is not None and global_table is not None:
            break

    main_table.fields.append(build_all_profiles_for_export(export_json, profile_jsons))
    global_table.fields.insert(1, get_globals())

    # Convert the modified AST back to Lua code
    return MakuluLuaPrinter(indent_size=1).visit(tree)

already_obfuscated = []

def setup_path_to_absolute(root):
    global profiles
    for _, profile_json in profiles.items():
        for file in profile_json["files"]:
            curr_path = file["path"]
            file["path"] = os.path.abspath(os.path.join(root, curr_path))

    globals_obj = get_globals_config()
    print(globals_obj)
    for file in globals_obj["files"]:
        curr_path = file["path"]
        file["path"] = os.path.abspath(os.path.join(root, curr_path))

def obfuscate_list_of_files(files, root):
    out_dir = os.path.abspath("./obfuscated")

    all_paths = files

    command = f"python ./Obfuscate.py {all_paths} -o {out_dir} -r {root}"
    subprocess.run(f"cd Obfuscator && {command}", shell=True, check=True)

def obfuscate_profiles(root):
    global profiles
    globals_obj = get_globals_config()

    all_files_list = set()

    for profile_name, profile_json in profiles.items():
        print('Obfuscating ' + profile_name)

        all_paths = [file['path'] for file in profile_json["files"]]
        all_files_list.update(all_paths)

    all_files_list.update([file['path'] for file in globals_obj["files"]])

    split_files = divide(min(cpu_count(), len(all_files_list)), all_files_list)

    to_send = [" ".join(vals) for vals in split_files]

    with Pool() as pool:
        pool.starmap(obfuscate_list_of_files, [(chunk, root) for chunk in to_send])

    for profile_name, profile_json in profiles.items():
        for file in profile_json["files"]:
            file["path"] = os.path.join("./obfuscated", file["path"])

    for file in globals_obj["files"]:
        file["path"] = os.path.join("./obfuscated", file["path"])

def make_each_profile_an_export():
    global exports
    global profiles

    for profile_name in profiles:
        exports[profile_name] = {
            "name": profile_name,
            "profiles": [profile_name]
        }

def make_all_profiles_an_export():
    global exports
    global profiles

    exports["AIO"] = {
        "name": "AIO",
        "profiles": list(profiles.keys())
    }

def make_an_export(export, export_json, profiles):
    print('Building ' + export + '...', end=' ')

    profile_start_time = time.time()
    modified_lua_code = modify_lua_ast(export_json, profiles)
    os.makedirs("out", exist_ok=True)

    with open("./out/Makulu_" + export + '.lua', 'w') as f:
        print('Creating ast took: %.2f ms' % ((time.time() - profile_start_time) * 1000), end='')
        f.write(modified_lua_code)
        print(". Overall time: %.2f ms" % ((time.time() - profile_start_time) * 1000))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                    prog='Makulu Auto Bundler',
                    description='Bundle all your profile ready to be imported into GGL',
                    epilog='Make with <3 from the Makulu team')

    parser.add_argument("-e", "--encrypt", help="Obfuscate our files", action="store_true")
    parser.add_argument('-r', '--file-root', type=str, help='Root directory for our files', required=False)
    parser.add_argument('-p', '--profiles', nargs='*', help='List of profiles to create')

    args = parser.parse_args()

    exports = load_exports_dict()
    profiles = load_profiles_dict()

    root = args.file_root or "../Rotations/"
    root = os.path.abspath(root)

    if args.encrypt:
        obfuscate_profiles(root)
    else:
        setup_path_to_absolute(root)

    make_each_profile_an_export()
    make_all_profiles_an_export()

    profile_list = None
    if args.profiles is not None:
        profile_list = []
        for profile in args.profiles:
            profile_list.append(profile.lower())

    for export, export_json in exports.items():
        if profile_list is not None:
            if export.lower() not in profile_list:
                continue

        make_an_export(export, export_json, profiles)
