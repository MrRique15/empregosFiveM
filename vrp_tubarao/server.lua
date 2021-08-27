local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_tubarao")
vRPps = {}
Tunnel.bindInterface("vrp_tubarao",vRPps)
Proxy.addInterface("vrp_tubarao",vRPps)

function vRPps.checkPermission()
  	local user_id = vRP.getUserId({source})
	-- return vRP.hasPermission({"teste.seila"})
	return true
end

function vRPps.ChecarQuantidade()
	local user_id = vRP.getUserId({source})
  	return vRP.getInventoryItemAmount({user_id,"barbatana"})
end

RegisterServerEvent("zeus:ColhendoCarne")
AddEventHandler("zeus:ColhendoCarne", function()
	local source = source
	local user_id = vRP.getUserId({source})
	local carnes = math.random(1,5)
    vRP.giveInventoryItem({user_id,"barbatana",carnes,true}) 
end)