fx_version 'adamant'
game 'gta5'

dependencies 'vrp'

ui_page 'html/ui.html'
files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/fonts/big_noodle_titling-webfont.woff',
    'html/fonts/big_noodle_titling-webfont.woff2',
    'html/fonts/pricedown.ttf',
}

server_scripts{
    "@vrp/lib/utils.lua",
    "nyo_tattoo_cfg.lua",
    "nyo_tattoo_sv.lua"
}

client_script {
    "@vrp/lib/utils.lua",
    "nyo_tattoo_cl.lua"
}

