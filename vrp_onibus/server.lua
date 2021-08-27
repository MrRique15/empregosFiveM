-- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- RESOURCE TUNNEL/PROXY
vRPon = {}
Tunnel.bindInterface("vrp_onibus",vRPon)
Proxy.addInterface("vrp_onibus",vRPon)
ONclient = Tunnel.getInterface("vrp_onibus")

cfg = module("vrp_onibus", "cfg/config")

function vRPon.finishJob(pontos)
	local user_id = vRP.getUserId(source)
	vRP.giveMoney(user_id, cfg.valor*pontos)
	vRPclient.notify(source,"Recebido ~g~R$"..cfg.valor*pontos.."~w~ pela corrida.")
end

RegisterNetEvent('start:busjob')
AddEventHandler("start:busjob", function()
	local source = source
	local user_id = vRP.getUserId(source)
	-- if user_id and vRP.hasPermission(user_id,cfg.permissao) then
		TriggerClientEvent("start:busjob",source)
	-- else
		-- vRPclient.notify(source,"~r~Não possui permissão.")
	-- end
end)