local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
job = {}
Tunnel.bindInterface("vrp_weazel",job)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇOES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_weazel:permissao')
AddEventHandler('vrp_weazel:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('vrp_weazel:permissao',player)
end)

function job.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("fotografia") <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,"fotografia",1)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
		end
	end
end