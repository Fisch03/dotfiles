import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import { icon_or_fallback, urgency_to_class } from '../../notification_popup.js';

const ICON_SIZE = 40;

function close_overlay(notification, contents) {
    return Widget.Overlay({
        passThrough: false,
        child: contents,
        marginBottom: 5,
        overlays: [
            Widget.EventBox({
                className: 'notification-close-button-container',
                hexpand: true,
                child: Widget.Button({
                    margin: 10,
                    className: 'close-button',
                    hpack: 'end',
                    vpack: 'center',
                    child: Widget.Icon({
                        icon: 'window-close-symbolic',
                        size: 30,
                        margin: 5,
                    }),
                    onClicked: () => notification.close()
                })
            })
            
        ]
    })
}

export const NotificationList = () => {
    const NotificationListItem = notification => close_overlay(notification, Widget.Box({
        className: (urgency_to_class(notification['urgency'])),
        hexpand: true,
        child: Widget.Box({
            margin: 5,
            children: [
                icon_or_fallback(notification),
                Widget.Box({
                    hexpand: true,
                    vpack: 'center',
                    vertical: true,
                    marginLeft: 3,
                    marginRight: 5,
                    children: [
                        Widget.Label({
                            visible: notification['summary'] != "",
                            hpack: 'start',
                            className: 'title-small',
                            truncate: 'end',
                            label: notification['summary'],
                        }),
                        notification['body'] != "" ? Widget.Label({
                            visible: notification['body'] != "",
                            hpack: 'start',
                            justification: 'left',
                            wrap: true,
                            wrapMode: 2,
                            label: notification['body'],
                        }) : undefined
                    ]
                })
            ]
        })
    }));

    return Widget.Scrollable({
        hscroll: 'never',
        vexpand: true,
        child: Widget.Box({
            hexpand: true,
            vexpand: true,
            vertical: true,

            className: 'notification-list',
            setup: widget => {
                /*
                widget.hook(Notifications, self => {
                    console.log(Notifications.notifications);
                });
                */

                widget.bind('children', Notifications, 'notifications', i => i.map(NotificationListItem));

                widget.hook(Notifications, self => {
                    self.visible = Notifications.notifications.length != 0;
                });
            }
        })
    })
}
