# https://github.com/cookiecutter/cookiecutter/issues/723#issuecomment-350561930
import os
import shutil

def remove(filepath):
    if os.path.isfile(filepath):
        os.remove(filepath)
    elif os.path.isdir(filepath):
        shutil.rmtree(filepath)

if "{{ cookiecutter.project_type }}" != "application":
    remove("bin")
    remove("Dockerfile")
