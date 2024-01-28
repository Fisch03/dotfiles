import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Gtk from "gi://Gtk";

const WORKSPACES_PER_MONITOR = 10;

const WORKSPACE_SIZE = 30;

export const Workspaces = (monitor) => {
    const i_to_w = (i) => i + monitor * WORKSPACES_PER_MONITOR;
    const w_to_i = (w) => w - monitor * WORKSPACES_PER_MONITOR;
    const w_on_curr = (w) => (i_to_w(0) <= w && w <= i_to_w(10))

    return Widget.EventBox({
        vpack: "center",
        onScrollUp: () => Hyprland.sendMessage(`dispatch workspace -1`),
        onScrollDown: () => Hyprland.sendMessage(`dispatch workspace +1`),
        className: 'bar-element',
        child: Widget.Box({
            children: Array.from({ length: WORKSPACES_PER_MONITOR }, (_, i) => i + 1).map(i => Widget.Button({
                attribute: { index: i, has_window: false, is_active: false },
                label: `${i}`,
                onClicked: () => Hyprland.sendMessage(`dispatch workspace ${i_to_w(i)}`),
                className: 'workspace',
                heightRequest: WORKSPACE_SIZE,
                widthRequest:  WORKSPACE_SIZE,
                vpack: "center",
                setup: widget => {
                    widget.on("draw", (self, cr) => {
                        const allocation = widget.get_allocation();
                        const { width, height } = allocation;

                        const c = widget.get_style_context().get_property("color", Gtk.StateFlags.NORMAL);

                        if(self.attribute.is_active) {
                            const bg_c = widget.get_style_context().get_property("background-color", Gtk.StateFlags.NORMAL);
                            cr.arc(width/2, height/2, width/2, 0, Math.PI*2);
                            cr.setSourceRGBA(bg_c.red, bg_c.green, bg_c.blue, 255);
                            cr.fill();

                            cr.arc(width/2, height/2, 4, 0, Math.PI*2);
                            cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha);
                            cr.fill();
                        } else if(self.attribute.has_window) {
                            cr.arc(width/2, height/2 + 10, 1.5, 0, Math.PI*2);
                            cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha);
                            cr.fill();
                        }
                    });
                }
            })),
            margin: 3,
            setup: (self) => self.hook(Hyprland, () => {
                if(!w_on_curr(Hyprland.active.workspace.id)) return;
                let id = w_to_i(Hyprland.active.workspace.id)

                let workspaces_with_window = []
                Hyprland.workspaces.forEach((workspace) => {
                    if(workspace.windows > 0) workspaces_with_window.push(workspace.id);
                });

                self.children.forEach(btn => {
                    let was_active = btn.attribute.is_active;
                    btn.attribute.is_active = btn.attribute.index == id
                    btn.toggleClassName('active-workspace', btn.attribute.is_active);
                    btn.label = btn.attribute.is_active ? "" : `${btn.attribute.index}`;
                    
                    let had_window = btn.attribute.has_window;
                    btn.attribute.has_window = workspaces_with_window.includes(i_to_w(btn.attribute.index));      
                    if(was_active != btn.attribute.is_active || had_window != btn.attribute.has_window) btn.queue_draw();
                })
            })
        })
    })
}