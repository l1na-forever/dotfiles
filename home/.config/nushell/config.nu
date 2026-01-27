$env.config.show_banner = false

alias ll = ls -l
alias fg = job unfreeze

# Theming
$env.config.table.mode = 'rounded'    

let color_config = {
    shape_garbage: { fg: "#eeeeee" bg: "#d4a2c8" attr: b }
}
$env.config.color_config = $color_config

$env.LS_COLORS = (vivid generate rose-pine)
