import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

export async function applyStyle() {
    await Utils.execAsync(`python ${App.configDir}/scripts/gen_colors.py ${App.configDir}/scss/_colors.scss ${App.configDir}/colors.json`);
    await Utils.execAsync(`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`);
    App.resetCss();
    App.applyCss(`${App.configDir}/style.css`);
}

export async function changeWallpaper() {
    const wallpaper = await Utils.execAsync(`python ${App.configDir}/scripts/wallpaper.py ${App.configDir}/wallpapers`);
    await applyStyle();

    return wallpaper;
}