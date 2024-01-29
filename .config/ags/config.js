import Gdk from 'gi://Gdk';

import { get_setting, launch_configurator } from './utils/settings.js';
const configuration_done = await get_setting("configuration_done")
if(configuration_done != true) {
    await launch_configurator()
}

import { changeWallpaper } from './utils/style.js';
await changeWallpaper();

import { Bar } from './bar/bar.js'
import { PanelRight } from './panels/panel_right/panel_right.js';
import { CornerTopleft, CornerTopright, CornerBottomleft, CornerBottomright } from './screen_corner.js';

const primary_monitor = await get_setting("primary_monitor")

async function per_monitor(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;

    let widgets = [];
    for(let i = 0; i < n; i++) {
        widgets.push(widget(i, i == primary_monitor))
    }
    return widgets;
}

const Windows = [
    per_monitor(Bar),
    PanelRight(primary_monitor),
    per_monitor(CornerTopleft),
    per_monitor(CornerTopright),
//    per_monitor(CornerBottomleft),
    per_monitor(CornerBottomright)
]

export default {
    windows: Windows.flat(1)
}