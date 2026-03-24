import luaparser.astnodes as astNode
from GGLGroups import ggl_group
import os

escape_dict = {
    "\a": r"\a",
    "\b": r"\b",
    "\c": r"\c",
    "\f": r"\f",
    "\n": r"\n",
    "\r": r"\r",
    "\t": r"\t",
    "\v": r"\v",
    "'": r"\'",
    '"': r"\"",
    "\0": r"\0",
    "\1": r"\1",
    "\2": r"\2",
    "\3": r"\3",
    "\4": r"\4",
    "\5": r"\5",
    "\6": r"\6",
    "\7": r"\7",
    "\8": r"\8",
    "\9": r"\9",
}

def raw(text):
    """Returns a raw string representation of text"""
    new_string = ""
    for char in text:
        found = escape_dict.get(char)

        if found is not None:
            new_string += found
        else:
            new_string += char
    return new_string

def build_code_snippet(json_info, idx, path_prefix=None, order_offset=0):
    file_loc = json_info["path"]
    order = json_info.get("order")
    name = json_info["name"]

    if json_info.get("cache") is not None:
        return json_info["cache"]

    if path_prefix is not None:
        file_loc = os.path.join(path_prefix, file_loc)

    with open(file_loc, 'r', errors="ignore") as f:
        try:
            code_snip = f.read()
        except Exception as e:
            print("\nError reading file: " + file_loc)
            raise e

    # code_snip = code_snip.replace('\'', '\\\'')
    # code_snip = code_snip.replace('\n', '\\n')

    code_params = {
        'Name': astNode.String(s=name),
        'Code': astNode.String(s=raw(code_snip)),
    }

    if order is not None:
        code_params['Order'] = astNode.Number(n=(order + order_offset))

    new_table_fields = [astNode.Field(key=astNode.String(s=k), value=v, between_brackets=True)
                        for k, v in code_params.items()]
    table = astNode.Table(new_table_fields, comments=[astNode.Comment(s="-- [" + str(idx) + "]")])

    json_info["cache"] = table
    return table

def build_all_code_snippets(json_blob, order_offset=0):
    all_snippets = []
    for idx, code_snip in enumerate(json_blob["files"]):
        code_snip_table = build_code_snippet(code_snip, idx + 1, order_offset=order_offset)

        all_snippets.append(code_snip_table)

    number_field = astNode.Field(key=astNode.String(s="n"), value=astNode.Number(n=len(json_blob["files"])), between_brackets=True)
    all_snippets.append(number_field)

    return all_snippets

def build_profile(profile_json):
    new_table = {  # New table to assign to the new key
        'Version': astNode.Number(n=101600),
        'ForceNoBlizzCC': astNode.TrueExpr(),
        'NumGroups': astNode.Number(n=6),
        'TextureName': astNode.String(s="Flat"),
        "CodeSnippets": astNode.Table(fields=build_all_code_snippets(profile_json, order_offset=20)),
        "Groups": ggl_group(),
        "Locked": astNode.TrueExpr(),
    }

    new_table_fields = [astNode.Field(key=astNode.String(s=k), value=v, between_brackets=True)
                        for k, v in new_table.items()]
    new_table_node = astNode.Table(fields=new_table_fields)

    profile_name = "Makulu - " + profile_json["name"]
    return astNode.Field(key=astNode.String(s=profile_name), value=new_table_node, between_brackets=True)

def build_all_profiles_for_export(export_json, profile_jsons):
    loaded_profiles = []
    for profile_names in export_json["profiles"]:
        profile_json = profile_jsons[profile_names]

        if not profile_json:
            raise Exception("Profile not found: " + profile_names)

        loaded_profiles.append(build_profile(profile_json))

    profile_fields = astNode.Table(fields=loaded_profiles)
    return astNode.Field(key=astNode.String(s="profiles"), value=profile_fields, between_brackets=True)
