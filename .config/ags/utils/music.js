import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

let relevant_player = undefined;
export function get_relevant_player() { 
    if(relevant_player == undefined) relevant_player = find_relevant_player();
    return relevant_player; 
}

Mpris.connect('player-changed', () => {
    relevant_player = find_relevant_player();
})

function find_relevant_player() {
    let players = Mpris.players;

    if(players.length == 0) return undefined;

    const mpd_or_first = (list) => { 
        const mpd = list.find((player) => player['name'] == "mpd");
        if(mpd != undefined && mpd['track-artists'] && mpd['track-title']) return mpd
        else                 return playing[0];
    }

    players = players.filter((player) => player['play-back-status'] != "Stopped")
    const playing = players.filter((player) => player['play-back-status'] == "Playing");
    
    if(playing.length > 0) return mpd_or_first(playing);
    else                   return mpd_or_first(players);
}

export async function find_cover(player) {
    let cover = undefined;

    if(player['track-cover-url'] != "") {
        const fileurl = player['track-cover-url'];
        cover = fileurl.replace('file://', '');
    } else if (player['name'] == "mpd") {
        const mpd_cover = await Utils.execAsync(`python ${App.configDir}/scripts/mpd_cover.py`);
        if(mpd_cover != "") cover = mpd_cover;
    }

    return cover;
}