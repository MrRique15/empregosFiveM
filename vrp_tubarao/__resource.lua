dependency "vrp"

client_script{ 
	"lib/Proxy.lua",
    "lib/Tunnel.lua",
	"client.lua"
}

server_script{
	"@vrp/lib/utils.lua",
	"server.lua"
}