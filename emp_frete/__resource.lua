resource_manifest_version '44febabe-d386-4res-coba-re627f4car37'

dependency 'vrp'

client_scripts {
    "@vrp/lib/utils.lua",
    "config/config.lua",
	"client/client.lua"
}

server_scripts {
	'@vrp/lib/utils.lua',
    "config/config.lua",
	'server/server.lua'
}