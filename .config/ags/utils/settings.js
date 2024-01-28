import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

export async function get_setting(key) {
    try {
        const settings = JSON.parse(await Utils.readFileAsync(`${App.configDir}/settings.json`));
        if(settings[key] != undefined) return settings[key]
        else                           return undefined
    } catch (error) {
        return undefined;
    }   
}

export async function launch_configurator() {
    await Utils.execAsync(`kitty python ${App.configDir}/scripts/configure.py --from-ags`);
}