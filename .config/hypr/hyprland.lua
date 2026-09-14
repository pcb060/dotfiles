---@module 'hl'

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Monitors/

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.2,
})

---------------------
---- APPLICATIONS ---
---------------------

-- See https://wiki.hypr.land/Configuring/Keywords/

local terminal = "kitty"
local fileManager = "thunar"
local launcher = "vicinae"
local browser = "firefox"
local statusbar = "waybar"
local wallpaper = "hyprpaper"
local idle = "hypridle"
local lock = "hyprlock"
local notifManager = "mako"

--------------
---- UTILS ---
--------------

local wbright = "~/.local/bin/wbrightnessctl"

------------------
---- AUTOSTART ---
------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(wallpaper)
    hl.exec_cmd(idle)
    hl.exec_cmd(statusbar)
    hl.exec_cmd(launcher .. " server")
    hl.exec_cmd(terminal)
    hl.exec_cmd(notifManager)
    hl.exec_cmd("udiskie --tray --notify")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("tailscale systray")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
end)

------------------------------
---- ENVIRONMENT VARIABLES ---
------------------------------

-- See https://wiki.hypr.land/Configuring/Environment-variables/

hl.env("XCURSOR_THEME", "capitaine-cursors")
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_THEME", "capitaine-cursors")
hl.env("HYPRCURSOR_SIZE", 24)

--------------
---- INPUT ---
--------------

-- See https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        kb_model = "",
        kb_options = "eurosign:5",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- See https://wiki.hypr.land/Configuring/Gestures

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

---------------
---- LAYOUT ---
---------------

-- See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Master-Layout/ for more

hl.config({
    master = {
        new_status = "master",
    },
})

-- https://wiki.hypr.land/Configuring/Variables/#misc

hl.config({
    misc = {
        force_default_wallpaper = 1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

--------------------
---- KEYBINDINGS ---
--------------------

-- See https://wiki.hypr.land/Configuring/Keywords/

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- See https://wiki.hypr.land/Configuring/Binds/

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launcher .. " toggle"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zeditor"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(launcher .. " deeplink vicinae://launch/clipboard/history"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(launcher .. " vicinae://launch/power/power-off"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lock))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move active window left/right/up/down
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Drag window
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { drag = true })

-- Switch workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace
for i = 1, 9 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Switch to previous/next workspace
hl.bind(mainMod .. " + Prior", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + Next", hl.dsp.focus({ workspace = "r+1" }))

-- Move active window to previous/next workspace
hl.bind(mainMod .. " + SHIFT + Prior", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + Next", hl.dsp.window.move({ workspace = "r+1" }))

-- Switch to previous/next tab in group
hl.bind(mainMod .. " + tab", hl.dsp.group.next({ forward = true }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.group.next({ forward = false }))

-- Screenshot binds with hyprshot
local screenshotDir = os.getenv("HOME") .. "/Pictures/Screenshots"
local shotOutput = "hyprshot -m output -o " .. screenshotDir
local shotRegion = "hyprshot -m region -o " .. screenshotDir
hl.bind("Print", hl.dsp.exec_cmd(shotOutput))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(shotOutput))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(shotRegion))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(shotRegion))

-- Dwindle keybinds
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = 1 })) -- respects waybar, gaps etc.
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.group.toggle())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(wbright .. " set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(wbright .. " set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

hl.layer_rule({
    name = "vicinae-blur",
    match = { namespace = "vicinae" },

    blur = true,
    ignore_alpha = 0,
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",

    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

--------------------
---- PERMISSIONS ---
--------------------

-- See https://wiki.hypr.land/Configuring/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--     ecosystem = {
--         enforce_permissions = 1,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------------
---- LOOK AND FEEL ---
----------------------

-- Refer to https://wiki.hypr.land/Configuring/Variables/

require("themes.vitesse-dark")

hl.config({
    general = {
        layout = "dwindle",
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
    },
})

hl.config({
    cursor = {
        no_hardware_cursors = false,
    },
})

hl.config({
    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

-- https://wiki.hypr.land/Configuring/Variables/#animations

hl.config({
    animations = {
        enabled = true,
    },
})

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
--        NAME,           X0,   Y0,   X1,   Y1
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
--           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
