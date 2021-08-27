fx_version 'adamant'
game 'gta5'


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/taximeter.ttf',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}