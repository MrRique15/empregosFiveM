local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
job = {}
Tunnel.bindInterface("vrp_gruppe6",job)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = 0
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_gruppe6:permissao')
AddEventHandler('vrp_gruppe6:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('vrp_gruppe6:permissao',player)
	segundos = 180
	processo = true
end)

RegisterServerEvent('vrp_gruppe6:receber')
AddEventHandler('vrp_gruppe6:receber', function(pagamento)
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		vRP.giveMoney(user_id,parseInt(pagamento))
		TriggerClientEvent("vrp_sound:source",source,'dinheiro',0.3)
	end
end)

RegisterServerEvent('vrp_gruppe6:roupa')
AddEventHandler('vrp_gruppe6:roupa', function()
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
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
		if processo then
			segundos = segundos - 1
			if segundos <= 0 then
				timers = {}
				processo = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK CAIXA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_gruppe6:checkcaixa')
AddEventHandler('vrp_gruppe6:checkcaixa', function(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if timers[id] == 0 or not timers[id] then
			timers[id] = 180
			TriggerClientEvent("vrp_gruppe6:startanim",source,id)
		else
			TriggerClientEvent("Notify",source,"aviso","O <b>Caixa Eletronico</b> foi restaurado a pouco tempo, aguarde <b>"..vRP.format(parseInt(timers[id])).." segundos</b> até que precise de um <b>reabastecimento</b> novamente.")
		end
	end
end)