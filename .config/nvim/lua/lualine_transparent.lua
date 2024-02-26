local colors = {
    surface                = 0,
    on_surface             = 7,
    outline                = 8,

    error                  = 1,

    tertiary               = 2,
    on_tertiary_container  = 10,

    secondary_container    = 3,
    on_secondary_container = 11,

    primary_container      = 4,
    on_primary_container   = 12,

    on_secondary           = 5,
    secondary              = 13,

    primary                = 6,

    transparent            = "NONE"
}

local lightline_transparent = {
    replace = {
        a = { fg = colors.on_secondary, bg = colors.secondary, gui = "bold", },
        b = { fg = colors.on_secondary_container, bg = colors.secondary_container },
        c = { fg = colors.on_surface, bg = colors.transparent },
    },
    inactive = {
        a = { fg = colors.secondary_container, bg = colors.tertiary, gui = "bold", },
        b = { fg = colors.secondary_container, bg = colors.tertiary },
        c = { fg = colors.on_surface, bg = colors.transparent },
    },
    visual = {
        a = { fg = colors.on_secondary, bg = colors.secondary, gui = "bold", },
        b = { fg = colors.on_secondary_container, bg = colors.secondary_container },
        c = { fg = colors.on_surface, bg = colors.transparent },
    },
    normal = {
        a = { fg = colors.on_primary_container, bg = colors.primary_container, gui = "bold", },
        b = { fg = colors.on_secondary_container, bg = colors.secondary_container },
        c = { fg = colors.on_surface, bg = colors.transparent },
    },
    insert = {
        a = { fg = colors.on_secondary, bg = colors.primary, gui = "bold", },
        b = { fg = colors.on_secondary_container, bg = colors.secondary_container },
        c = { fg = colors.on_surface, bg = colors.transparent },
    },
}

return lightline_transparent
