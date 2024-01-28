import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

export const Tray = () => {
    const SysTrayItem = item => Widget.Button({
        marginLeft: 4,
        child: Widget.Icon({size: 30}).bind('icon', item, 'icon'),
        tooltipMarkup: item.bind('tooltip-markup'),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
    });

    return Widget.Box({
        className: 'bar-element-secondary',
        vpack: "end",
        hexpand: true,
        heightRequest: 50,
        
        child: Widget.Box({
            hpack: 'center',
            hexpand: true,
            margin: 10,
            setup: widget => {
                widget.bind('children', SystemTray, 'items', i => i.map(SysTrayItem))
            }
        })
    })
}