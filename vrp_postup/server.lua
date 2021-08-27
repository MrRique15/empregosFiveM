local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
job = {}
Tunnel.bindInterface("vrp_postup",job)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_postup:permissao')
AddEventHandler('vrp_postup:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('vrp_postup:permissao',player)
end)

RegisterServerEvent('vrp_postup:receber')
AddEventHandler('vrp_postup:receber', function(pagamento)
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		vRP.giveMoney(user_id,parseInt(pagamento))
		TriggerClientEvent("vrp_sound:source",source,'dinheiro',0.3)
	end
end)

RegisterServerEvent('vrp_postup:roupa')
AddEventHandler('vrp_postup:roupa', function()
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		vRP.removeCloak(source)
	end
end)

function job.SaveIdleCustom(old_custom)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.save_idle_custom(source,old_custom)
end