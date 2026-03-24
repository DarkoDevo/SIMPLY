import argparse
import pathlib
import os
import subprocess

parser = argparse.ArgumentParser(
                prog='Obfuscator',
                description='Obfuscates our files and places them into a directory for us',
                epilog='Make with <3 from the Makulu team')

parser.add_argument('Files', type=str, nargs='+',
                    help='All our files we want to obfuscate')
parser.add_argument('-r', '--file-root', type=pathlib.Path, help='Root directory for our files', required=False)
parser.add_argument('-o', '--out', type=pathlib.Path, help='Out directory for our files', required=True)

args = parser.parse_args()


if args.file_root is not None:
    file_root = os.path.abspath(args.file_root)
else:
    file_root = args.file_root
out_dir = os.path.abspath(args.out)

os.makedirs(out_dir, exist_ok=True)

for file in args.Files:
    read_location = file
    if args.file_root is not None:
        read_location = os.path.abspath(os.path.join(file_root, file))
    write_path = os.path.join(out_dir, file)

    os.makedirs(os.path.dirname(write_path), exist_ok=True)
    command = f"lua ./cli.lua --Lua51 --config ../Config.lua {read_location} --out {write_path} "

    subprocess.run(f"cd ./Prometheus && {command}", shell=True, check=True)
