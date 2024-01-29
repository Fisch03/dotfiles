import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Gtk from "gi://Gtk";

import { find_relevant_player } from '../utils/music.js';

export const MusicBar = () => {
    return Widget.Box({
        className: 'bar-element',
        hpack: 'center',
        vertical: true,
        widthRequest:  500,
        children: [
            Widget.Label({
                justification: 'center',
                vexpand: true,
                marginLeft: 10,
                marginRight: 10,
                vpack: "center",
                setup: widget => {
                    widget.hook(Mpris, label => {
                        const player = find_relevant_player(Mpris.players);
                        if(player == undefined) {
                            label.label = "Nothing playing right now!"
                            return;
                        }
                        
                        label.label = `${player['track-artists'].join(', ')} • ${player['track-title']}`
                    })
                }
            }),
            Widget.DrawingArea({
                vpack: 'end',
                attribute: { progress: 0 },
                className: 'music-progress',
                setup: widget => {
                    const update_progress = (self) => {
                        const player = find_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        if(player.length == -1 || player.position == -1) {
                            self.visible = false;
                            return
                        }

                        self.visible = true;
                        let progress_old = self.attribute.progress
                        self.attribute.progress = Math.max(player.position / player.length, 0);
    
                        if(progress_old != self.attribute.progress) self.queue_draw();
                    }

                    widget.poll(1000,  update_progress);
                    widget.hook(Mpris, update_progress, 'player-changed');

                    widget.on("draw", (self, cr) => {
                        function chord_len_at_d(d, r) {
                            return 2 * Math.sqrt(Math.pow(r, 2) - Math.pow(d, 2));
                        }
                        
                        const bar_height = 3;
                        
                        widget.set_size_request(0,bar_height);
                        const allocation = widget.get_allocation();
                        const { width, height } = allocation;

                        const r = 20;
                        const d = r - bar_height;

                        const upper_len = chord_len_at_d(d, r) / 2;
                        const upper_angle = Math.sinh(upper_len/r);
                        
                        const t_l = {x: r - upper_len,         y: height - bar_height};
                        const t_r = {x: width - r + upper_len, y: height - bar_height};
                        const b_l = {x: r,                       y: height};
                        const b_r = {x: width - r,               y: height};

                        const c_l = {x: r,         y: height - r};
                        const c_r = {x: width - r, y: height - r};

                        
                        const bar_width = (t_r.x - t_l.x) * self.attribute.progress 

                        const map = (x, a, b, c, d) => (x-a)/(b-a) * (d-c) + c;

                        cr.moveTo(t_l.x, t_l.y);
                        cr.lineTo(t_l.x + bar_width, t_r.y);
                        
                        if(t_l.x + bar_width < b_l.x) {
                            const height = map(chord_len_at_d(r - bar_width, r)/2, 0, r, 0, bar_height);
                            cr.lineTo(t_l.x + bar_width, t_r.y + height);
                            const lower_angle = map(Math.sinh((chord_len_at_d(r - bar_width, r)/2)/r), 0, Math.PI/2, upper_angle, 0);
                            cr.arc(c_l.x, c_l.y, r, Math.PI/2 + lower_angle, Math.PI/2 + upper_angle)
                        } else if(t_l.x + bar_width < b_r.x) {
                            cr.lineTo(t_l.x + bar_width, b_r.y);
                            cr.lineTo(b_l.x, b_l.y);
                            cr.arc(c_l.x, c_l.y, r, Math.PI/2, Math.PI/2 + upper_angle);
                        } else {
                            const width = (t_l.x + bar_width) - b_r.x;
                            const height = map(chord_len_at_d(r - width, r)/2, 0, r, bar_height, 0);
                            cr.lineTo(b_r.x + width, t_r.y + height);

                            //console.log(Math.sinh((chord_len_at_d(r - width, r)/2)/r))
                            const lower_angle = map(Math.sinh((chord_len_at_d(r - width, r)/2)/r), 0, Math.PI/2, 0, upper_angle);
                            cr.arc(c_r.x, c_r.y, r, Math.PI/2 - lower_angle, Math.PI/2);
                            cr.lineTo(b_l.x, b_l.y);
                            cr.arc(c_l.x, c_l.y, r, Math.PI/2, Math.PI/2 + upper_angle);
                        }

                        const c = widget.get_style_context().get_property("color", Gtk.StateFlags.NORMAL);
                        cr.closePath();
                        cr.setSourceRGBA(c.red, c.green, c.blue, c.alpha);
                        cr.fill();
                    })
                }
            })
        ]
    })
}