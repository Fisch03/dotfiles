import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

export const Clock = () => {
    return Widget.Box({
        className: 'bar-element-secondary',
        hpack: 'start',
//        vertical: true,
        children: [
            Widget.Label({
                className: 'time',
                marginLeft: 10,
                vpack: 'center',
                setup: widget => {
                    widget.poll(5000, self => {
                        Utils.execAsync('date +%H:%M')
                            .then(out => { self.label = out })
                    })
                }
            }),
            Widget.Label({
                marginLeft: 20,
                marginRight: 10,
                justification: 'center',
                vpack: 'center',
                setup: widget => {
                    widget.poll(5000, self => {
                        Utils.execAsync('date "+%A, %d.%m."')
                            .then(out => { self.label = out })
                    })
                }
            })
        ]
    })
}