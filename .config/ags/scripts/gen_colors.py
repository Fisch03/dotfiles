import os, re, sys, json

import pywal

if(len(sys.argv) < 3):
    print("Please supply an output path for the css and the kitty files")
    exit()

from material_color_utilities_python import *

wallpaper = os.popen("swww query").read().splitlines()[0]
wallpaper = re.findall('image: ([\s\?]?.*)', wallpaper)[0]

img = Image.open(wallpaper)
basewidth = 128
wpercent = (basewidth/float(img.size[0]))
hsize = int((float(img.size[1])*float(wpercent)))
img = img.resize((basewidth,hsize),Image.Resampling.LANCZOS)
#img.save('test.jpg')
theme = themeFromImage(img)['schemes']['dark']

theme_str = ""
def add_color(key, color):
    global theme_str
    theme_str += f"${key}: {hexFromArgb(color)};\n"

add_color("primary", theme.get_primary())
add_color("on-primary", theme.get_onPrimary())
add_color("primary-container", theme.get_primaryContainer())
add_color("on-primary-container", theme.get_onPrimaryContainer())

theme_str += "\n"
add_color("secondary", theme.get_secondary())
add_color("on-secondary", theme.get_onSecondary())
add_color("secondary-container", theme.get_secondaryContainer())
add_color("on-secondary-container", theme.get_onSecondaryContainer())

theme_str += "\n"
add_color("tertiary", theme.get_tertiary())
add_color("on-tertiary", theme.get_onTertiary())
add_color("tertiary-container", theme.get_tertiaryContainer())
add_color("on-tertiary-container", theme.get_onTertiaryContainer())

theme_str += "\n"
add_color("error", theme.get_error())
add_color("on-error", theme.get_onError())
add_color("error-container", theme.get_errorContainer())
add_color("on-error-container", theme.get_onErrorContainer())

theme_str += "\n"
add_color("surface", theme.get_surface())
add_color("on-surface", theme.get_onSurface())

theme_str += "\n"
add_color("outline", theme.get_outline())

with open(os.path.join(sys.argv[1]), "w") as f:
    f.write(theme_str)

pywal_dict = {
    "wallpaper": wallpaper,
    "alpha": "100",
    "special": {
        "background": hexFromArgb(theme.get_surface()),
        "foreground": hexFromArgb(theme.get_onSurface()),
        "cursor":     hexFromArgb(theme.get_onSurface()),
    },
    "colors": {
        "color0":     hexFromArgb(theme.get_surface()),

        "color1":     hexFromArgb(theme.get_error()),
        "color2":     hexFromArgb(theme.get_tertiary()),
        "color3":     hexFromArgb(theme.get_secondaryContainer()),
        "color4":     hexFromArgb(theme.get_primaryContainer()),  
        "color5":     hexFromArgb(theme.get_onSecondary()),
        "color6":     hexFromArgb(theme.get_primary()),

        "color7":     hexFromArgb(theme.get_onSurface()),

        "color8":     hexFromArgb(theme.get_outline()),

        "color9":      hexFromArgb(theme.get_error()), 
	"color10":     hexFromArgb(theme.get_onTertiaryContainer()),
        "color11":     hexFromArgb(theme.get_onSecondaryContainer()),
        "color12":     hexFromArgb(theme.get_onPrimaryContainer()),  
        "color13":     hexFromArgb(theme.get_secondary()),
        "color14":     hexFromArgb(theme.get_primary()),

        "color15":     hexFromArgb(theme.get_onSurface()),
    }
}
pywal.sequences.send(pywal_dict)
json = json.dumps(pywal_dict)
with open(os.path.join(sys.argv[2]), "w") as f:
    f.write(json)
