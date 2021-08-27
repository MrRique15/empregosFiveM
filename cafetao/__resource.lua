--ARAMUNI MOD'S SCRIPT TEMPLATE

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
	"@vrp/lib/utils.lua", -- Carrega o framework VRPEX
	"client.lua", -- carrega o arquivo client.lua
	"funcoes.lua",
	"config.lua"
}

server_scripts {
	"@vrp/lib/utils.lua", -- Carrega o framework VRPEX
	"config.lua",
	"server.lua" -- Carrega o server.lua
}
