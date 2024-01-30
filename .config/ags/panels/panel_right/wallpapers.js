import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { changeWallpaper } from '../../utils/style.js';

export const Wallpapers = () => {
    return Widget.Box({
        hexpand: true,
        marginBottom: 10,
        children: [
            Widget.Button({
                hexpand: true,
                className: 'bar-element',
                child: Widget.Label({
                    margin: 10,
                    label: "Magic Wallpaper Button",
                }),
                onClicked: changeWallpaper
            }),
        ]
    })
}