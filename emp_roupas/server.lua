local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
job = {}
Tunnel.bindInterface("emp_roupas",job)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('emp_roupas:permissao')
AddEventHandler('emp_roupas:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('emp_roupas:permissao',player)
end)

RegisterServerEvent('emp_roupas:receber')
AddEventHandler('emp_roupas:receber', function(pagamento)
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		vRP.giveMoney(user_id,parseInt(pagamento))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.3)
	end
end)

RegisterServerEvent('emp_roupas:roupa')
AddEventHandler('emp_roupas:roupa', function()
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

function job.checkItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomendaroupa",1) then			
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..'1'.."x Encomenda de Roupas</b>.")
		end
	end
end