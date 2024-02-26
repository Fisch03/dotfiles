import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

import { find_cover, get_relevant_player } from '../../utils/music.js';

export const MusicControls = (linked_separator) => {
    const Title = () => Widget.Box({
        marginTop: 8,
        marginLeft: 10,
        marginRight: 10,
        vertical: true,
        children: [
            Widget.Label({
                className: 'title',
                wrap: true,
                //truncate: 'end',
                justification: 'center',
                setup: widget => {
                    widget.hook(Mpris, self => {
                        const player = get_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        self.label = player['track-title'];
                    }, 'player-changed');
                }
            }),
            Widget.Label({
                className: 'music-controls-artists',
                //truncate: 'end',
                wrap: true,
                justification: 'center',
                setup: widget => {
                    widget.hook(Mpris, self => {
                        const player = get_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        if(player['track-artists'].length == 0 || player['track-artists'][0] == "") {
                            self.visible = false;
                            return;
                        }

                        self.visible = true;

                        self.label = `by ${player['track-artists'].join(', ')}`;
                    }, 'player-changed');
                }
            })
        ]
    })

    

    const CoverArt = () => Widget.Overlay({
        child: Widget.Icon({
            className: 'music-cover',
            margin: 10,
            marginBottom: 5,
            attribute: { aspect: 1 },
            setup: widget => {
                widget.hook(Mpris, self => {
                    const player = get_relevant_player(Mpris.players);
                    if(player == undefined) return;

                    find_cover(player).then(cover => {
                        if(cover == undefined) {
                            self.visible = false;
                            return;
                        }

                        self.visible = true;
                        self.css = `background-image: url("${cover}");`

                        Utils.execAsync(`identify -format '%w %h' ${cover}`).then(response => {
                            let [ width, height ] = response.split(" ");
                            const aspect_ratio = height/width;
                            
                            self.attribute.aspect = aspect_ratio;
                            self.queue_draw();
                        });
                    })
                }, 'player-changed');

                widget.on("draw", (self, cr) => {
                    const allocation = widget.get_allocation();
                    const { width } = allocation;
                    widget.set_size_request(width, width * self.attribute.aspect);
                });
            }
        }),
        overlays: [Widget.Box({
            vpack: 'end',
            hpack: 'end',
            marginBottom: 13,
            marginRight: 18,
            widthRequest: 80,
            className: 'primary-element',
            child: Widget.Label({
                hexpand: true,
                justification: "center",
                margin: 5,
            }),
            setup: widget => {
                const update_times = (self) => {
                    const player = get_relevant_player(Mpris.players);
                    if(player == undefined) return;

                    if(player.length == -1 || player.position == -1) {
                        self.visible = false;
                        return
                    }

                    self.visible = true;
                    
                    // Horrible Date and String manipulations :3
                    const len  = new Date(player.length   * 1000);
                    const prog = new Date(player.position * 1000);

                    const prog_min = String(prog.getMinutes())
                    const prog_sec = String(prog.getSeconds()).padStart(2, '0');
                    const len_min  = String(len.getMinutes())
                    const len_sec  = String(len.getSeconds()) .padStart(2, '0');
                    self.children[0].label = `${prog_min}:${prog_sec}/${len_min}:${len_sec}`
                }

                widget.poll(1000,  update_times);
                widget.hook(Mpris, update_times, 'player-changed');
            }
        })]
    })

    const ControlButtons = () => Widget.Box({
        hexpand: true,
        hpack: 'center',
        marginBottom: 5,
        children: [
            Widget.Button({
                className: 'primary-button',
                margin: 5,
                child: Widget.Icon({
                    margin: 10,
                    size: 20,
                    icon: 'media-skip-backward',
                }),
                setup: widget => {
                    widget.hook(Mpris, self => {
                        const player = get_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        self.visible = player['can-go-prev'];
                    })
                },
                onPrimaryClick: () => {
                    const player = get_relevant_player(Mpris.players);
                    if(player == undefined) return;

                    player.previous();
                }
            }),
            Widget.Button({
                className: 'primary-button',
                margin: 5,
                child: Widget.Icon({
                    margin: 10,
                    size: 20,
                    icon: 'media-playback-start',
                }),
                setup: widget => {
                    widget.hook(Mpris, self => {
                        const player = get_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        self.child.icon = player['play-back-status'] == "Playing" ? 'media-playback-pause' : 'media-playback-start';
                    })
                },
                onPrimaryClick: () => {
                    const player = get_relevant_player(Mpris.players);
                    if(player == undefined) return;

                    player.playPause();
                }
            }),
            Widget.Button({
                className: 'primary-button',
                margin: 5,
                child: Widget.Icon({
                    margin: 10,
                    size: 20,
                    icon: 'media-skip-forward',
                }),
                setup: widget => {
                    widget.hook(Mpris, self => {
                        const player = get_relevant_player(Mpris.players);
                        if(player == undefined) return;

                        self.visible = player['can-go-next'];
                    })
                },
                onPrimaryClick: () => {
                    const player = get_relevant_player(Mpris.players);
                    if(player == undefined) return;

                    player.next();
                }
            })
        ]
    })

    return Widget.Box({
        className: 'secondary-container',
        vertical: true,
        children: [
            Title(),
            CoverArt(),
            ControlButtons()
        ],
        setup: widget => {
            widget.hook(Mpris, self => {
                const player = get_relevant_player(Mpris.players);
                self.visible = player != undefined
                linked_separator.visible = self.visible;
            }, 'player-changed');
        }
    })
}
