import os, glob, sys, random, re

if(len(sys.argv) < 1):
    print("Please supply a path containing wallpapers")
    exit()

wallpapers = glob.glob(f"{sys.argv[1]}/*")
current = os.popen("swww query").read().splitlines()[0]
current = re.findall('image: ([\s\?]?.*)', current)

if(len(current) == 0):
    current = "whatever"
else:
    current = current[0]

if(len(wallpapers) > 1 and current in wallpapers):
    wallpapers.remove(current) 
wallpaper = random.choice(wallpapers)


os.popen(f"swww img -t wipe --transition-angle 30 --transition-fps 144 {wallpaper}")
print(wallpaper)