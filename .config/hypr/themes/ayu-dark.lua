---@module 'hl'

hl.config({
    general = {
        col = {
            active_border   = { colors = { "rgba(e6b450ee)", "rgba(deae4dee)" }, angle = 45 },
            inactive_border = "rgba(686868aa)",
        },
    },
})

hl.config({
    group = {
        col = {
            border_active        = "rgb(e6b353)",
            border_inactive      = "rgb(1b1f29)",
            border_locked_active = "rgb(fdb04c)",
        },
        groupbar = {
            col = {
                active   = "rgb(e6b353)",
                inactive = "rgb(1b1f29)",
            },
            text_color  = "rgb(bfbdb6)",
            font_family = "Iosevka Nerd Font",
            font_size   = 14,
        },
    },
})

hl.config({
    decoration = {
        shadow = {
            color = "rgba(0a0a0aee)",
        },
    },
})
