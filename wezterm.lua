local wezterm = require 'wezterm';

return {
    color_scheme = "Adventure",
    font_size = 12.0,
    font = wezterm.font("Source Code Pro"),
    set_environment_variables = {
        TERM = "xterm-256color-italic",
    },
    default_prog = {"wsl"},
    launch_menu = {
        {
            args = {"cmd.exe"}
        },
    },
};
