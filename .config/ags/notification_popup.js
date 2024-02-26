import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
const Popups = Notifications.bind('popups');

const ICON_SIZE = 40;

export const icon_or_fallback = (notification) => {
    const icon_container = (icon) => Widget.Box({
        margin: 5,
        child: icon
    });

    if(notification['image']){
        return icon_container(Widget.Box({
            className: 'notification-icon',
            css: `background-image: url('${notification['image']}');`,
            widthRequest: ICON_SIZE+5,
            heightRequest: ICON_SIZE+5,
            vpack: 'start',
            /*setup: widget => {
                widget.on("draw", (self, cr) => {
                    const allocation = self.get_allocation();
                    const { width } = allocation;
                    self.set_size_request(width, width); //force square
                });
            }*/
        }))
    } else {
        return icon_container(Widget.Icon({
            className: 'notification-icon',
            size: ICON_SIZE,
            icon: 'user-available-symbolic'
        }));
    }
}

export const urgency_to_class = (urgency) => {
    switch(urgency) {
        case "critical":
            return 'primary-container';
        case "normal":
            return 'secondary-container';
        default:
            return 'tertiary-container';
    }
} 

export const Notification = n => {
    return Widget.EventBox({
        on_primary_click: () => n.dismiss(),
        child: Widget.Box({
            className: urgency_to_class(n.urgency),
            hexpand: true,
            child: Widget.Box({
                margin: 5,
                children: [
                    icon_or_fallback(n),
                    Widget.Box({
                        hexpand: true,
                        vpack: 'center',
                        vertical: true,
                        marginLeft: 3,
                        marginRight: 5,
                        children: [
                            Widget.Label({
                                visible: n['summary'] != "",
                                hpack: 'start',
                                className: 'title-small',
                                truncate: 'end',
                                label: n['summary'],
                            }),
                            n['body'] != "" ? Widget.Label({
                                visible: n['body'] != "",
                                hpack: 'start',
                                justification: 'left',
                                wrap: true,
                                wrapMode: 2,
                                label: n['body'],
                            }) : undefined
                        ]
                    })
                ]
            })
        })
    })
}

export const NotificationPopup = (monitor = 0) => {
    return Widget.Window({
        monitor,
        name: `notifications${monitor}`,
        anchor: ['top', 'right'],
        child: Widget.Box({
            vertical: true,
            children: Popups.as(popups => popups.map(Notification))
        })
    })
}
