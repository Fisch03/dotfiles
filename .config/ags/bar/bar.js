import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import { Clock } from './clock.js';

import { Workspaces } from "./workspaces.js";

import { MusicBar } from "./music_bar.js";
import { PanelRightExpander } from "../panels/panel_right/panel_right.js";

export const Bar = (monitor = 0, is_primary = true) => {
    const left_modules = Widget.CenterBox({
        marginRight: 10,
        hexpand: true,

        start_widget: Clock(),
    })

    const right_modules = Widget.CenterBox({
        marginLeft: 10,
    })
    if(is_primary) {
        right_modules.start_widget = MusicBar();
        right_modules.end_widget   = PanelRightExpander(monitor);
    }

    return Widget.Window({
        monitor,
        name: `bar${monitor}-blur`,
        anchor: ['top', 'left', 'right'],
        exclusivity: 'exclusive',
        child: Widget.CenterBox({
            margin: 10,
            start_widget: left_modules,
            center_widget: Workspaces(monitor),
            end_widget: right_modules
        }),
        className: 'bar',
    });
}