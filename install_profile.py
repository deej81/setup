import sys
from pathlib import Path
import subprocess
import yaml

# declare function install package
def install_package(pathToConfig):
    with open(pathToConfig) as f:
        config = yaml.safe_load(f)

        # print package name
        print("installing " + config["name"])
        install_to_pacman(config)
        make_config_links(config)

def install_to_pacman(config):
    if(config["package"]["source"] == "aur"):
        # run yay -Qs to check if package is installed
        # if not, run yay -S

        # check if package is installed
        task = subprocess.run(["yay", "-Qs", config["package"]["name"]], stdout=subprocess.PIPE)
        if(task.stdout == b''):
            print(config["package"]["name"] + " is not installed")
            task = subprocess.run(["yay", "-S", config["package"]["name"], "--noconfirm"])
        else:
            print(config["package"]["name"] + " is installed")
        

        

def make_config_links(config):
    directory = "./packages/" + config["name"] + "/config/."
    target = str(Path.home()) + "/.config/" + config["config_directory"]+"/"

    print("files to link: " + str(directory))
    print("making directory " + str(target))

    subprocess.run(["mkdir", "-p", target])
    subprocess.run(["cp", "-lrf", directory, target])


if (args_count := len(sys.argv)) > 2:
    print(f"One argument expected, got {args_count - 1}")
    raise SystemExit(2)
elif args_count < 2:
    print("You must specify the target directory")
    raise SystemExit(2)

target_file = Path("profiles/" + sys.argv[1] + ".yml")

if not target_file.exists():
    print("The target profile doesn't exist")
    raise SystemExit(1)

with open(target_file) as f:
    profile = yaml.safe_load(f)

    # print package names
    for package in profile["packages"]:
        install_package("packages/" + package + "/package.yml")


