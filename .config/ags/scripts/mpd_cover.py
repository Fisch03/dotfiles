import os, glob, re

mpd_config_path = os.path.join(os.path.expanduser('~'), '.config/mpd/mpd.conf')
music_directory = ""
with open(mpd_config_path) as f:
    lines = f.readlines()
    for line in lines:
        if line.startswith("#"):
            continue
        elif line.startswith("music_directory"):
            music_directory = re.findall('"(.+)"', line)[0]

if(music_directory == ""):
    raise Exception("Failed to find mpd music_directory")

music_directory = os.path.expanduser(music_directory)

song_file_relative = os.popen("mpc --format %file% current").read()
song_file = os.path.join(music_directory, song_file_relative) 
song_path = os.path.dirname(song_file)
song_path = glob.escape(song_path)

song_path_pngs = glob.glob(os.path.join(song_path, "*.png"))
song_path_jpgs = glob.glob(os.path.join(song_path, "*.jpg"))

if(len(song_path_pngs) > 0):
    for png in song_path_pngs:
        if("cover" in png.lower()):
            print(png)
            exit()
    print(song_path_pngs[0])

elif(len(song_path_jpgs) > 0):
    for jpg in song_path_jpgs:
        if("cover" in jpg.lower()):
            print(jpg)
            exit()
    print(song_path_jpgs[0])