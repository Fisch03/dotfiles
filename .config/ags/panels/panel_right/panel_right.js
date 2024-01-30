import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import PanelService from '../panel_service.js'

import { MusicControls } from './music_controls.js';
import { Wallpapers } from './wallpapers.js';
import { NotificationList } from './notification_list.js';
import { Tray } from './tray.js';



const PANEL_RIGHT_ID = 0; // Has to be unique!

export const PanelRight = (monitor = 0) => {
    const Separator = () => Widget.Box({
        hexpand: true,
        margin: 100,
        marginTop: 10,
        marginBottom: 10,
        className: 'separator',
    })

    const PanelContents = [
        MusicControls(),
        Separator(),
        NotificationList(),
        Separator(),
        Wallpapers(),
        Tray()
    ]

    return Widget.Window({
        monitor,

        name: `right${monitor}-blur`,
        anchor: ['top', 'bottom', 'right'],
        exclusivity: 'exclusive',
        child: Widget.Scrollable({
            vscroll: 'never',
            className: 'panel-right-container panel-right-container-hidden',
            //className: 'panel-right-container',
            child: Widget.Box({
                margin: 20,
                vertical: true,
                children: PanelContents,
            }),
            setup: widget => {
                widget.hook(PanelService, (self, state) => {
                    if(state == undefined || state.id != PANEL_RIGHT_ID) return;
                    
                    self.toggleClassName('panel-right-container-hidden', !state.state);
                }, 'panel-changed')
            }
        }),
    });
}

export const PanelRightExpander = (monitor = 0) => {
    return Widget.Box({
        className: 'bar-element-secondary',
        hpack: "end",
        
        child: Widget.Button({
            widthRequest: 40,
            onPrimaryClick: () => PanelService.toggle_panel(PANEL_RIGHT_ID),
            child: Widget.Icon({
                icon: 'go-previous',
                setup: widget => {
                    widget.hook(PanelService, (self, state) => {
                        if(state == undefined || state.id != PANEL_RIGHT_ID) return;
                        
                        self.icon = state.state ? 'go-next' : 'go-previous';
                    }, 'panel-changed')
                }
            })
        }),
    })
}