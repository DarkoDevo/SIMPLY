from os import listdir
from os.path import isfile, join
import json

def load_directory_of_jsons(mypath):
    onlyfiles = [join(mypath, f) for f in listdir(mypath) if isfile(join(mypath, f))]

    # Open all the files from onlyfiles and read them into a list of strings
    opened_files = []
    for file_name in onlyfiles:
        with open(file_name, 'r') as f:
            opened_files.append(f.read())

    json_blobs = [json.loads(f) for f in opened_files]

    profile_dictionary = {}

    for blob in json_blobs:
        profile_dictionary[blob['name']] = blob

    return profile_dictionary

def load_profiles_dict():
    return load_directory_of_jsons('./Profiles')

def load_exports_dict():
    return load_directory_of_jsons('./Exports')