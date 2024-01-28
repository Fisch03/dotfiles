import os, pathlib, json, sys, time

print("---- Dotfiles configurator ----\n")

settings_file_path = os.path.join(pathlib.Path(__file__).parent.parent.absolute(), "settings.json")

# Load current settings
settings = {}
if os.path.isfile(settings_file_path):
    with open(settings_file_path, "r") as f:
        settings = json.load(f)
        print("Current Settings: ")
        print(json.dumps(settings, indent=2))
        print("")

# Setup Primary Monitor
monitors = json.load(os.popen("hyprctl monitors -j"))

print("Detected Monitors: ")
for monitor in monitors:
    print(f"Monitor {monitor['id']}: {monitor['name']} - {monitor['width']}x{monitor['height']}@{monitor['refreshRate']}")

primary = -1
while(primary == -1):
    try:
        choice = int(input("Which one of these should be the primary monitor? "))
        if(choice < 0 or choice > len(monitors)-1):
            print("Choice out of range.")
        else:
            primary = choice
    except ValueError:
        print("Invalid input.")

settings['primary_monitor'] = primary
print("")

# Write Settings back to file
settings['configuration_done'] = True

with open(settings_file_path, "w") as f:
    json.dump(settings, f)

if(len(sys.argv) > 1 and sys.argv[1] == "--from-ags"):
    print(f"Configuration done. You can rerun this configurator at any time by running 'dots_configure' in a terminal")
    input("Press any key to continue...")
else:
    print("Configuration done. Restarting ags...")
    os.popen("killall ags >/dev/null 2>&1")
    time.sleep(0.5)
    os.popen("/usr/bin/ags >/dev/null 2>&1 &").read()
    time.sleep(0.5)
    print(f"Finished!")