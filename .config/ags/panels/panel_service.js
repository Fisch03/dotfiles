import Service from 'resource:///com/github/Aylur/ags/service.js';

class PanelService extends Service {
    static {
        Service.register(this,
            {
                'panel-changed': ['jsobject'],
            }
        );
    }

    #panelstates = {}
    #timeout = false;

    #start_timeout() {
        this.#timeout = true;
        setTimeout(() => { this.#timeout = false }, 100);
    }

    open_panel(id) {
        if(this.#timeout) return;
        this.#panelstates[id] = true;
        this.emit('panel-changed', {id: id, state: true});
        this.#start_timeout();
    }
    
    close_panel(id) {
        if(this.#timeout) return;
        this.#panelstates[id] = false;
        this.emit('panel-changed', {id: id, state: false});
        this.#start_timeout();
    }

    toggle_panel(id) {
        if(this.#timeout) return;
        if(this.#panelstates[id] == undefined) this.open_panel(id);
        else {
            this.#panelstates[id] = !this.#panelstates[id];
            this.emit('panel-changed', {id: id, state: this.#panelstates[id]});
            this.#start_timeout();
        }
    }

    constructor() {
        super();
    }

    connect(event = 'panel-changed', callback) {
        return super.connect(event, callback);
    }
}

const panelService = new PanelService;

export default panelService;