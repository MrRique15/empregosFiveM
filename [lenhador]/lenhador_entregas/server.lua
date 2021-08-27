local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("lenhador_entregas",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookmonster = ""


function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(10,10)	
	end
	TriggerClientEvent("quantidade-tora",source,parseInt(quantidade[source]))
end

local tora = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(tora) do
            if v > 0 then
                tora[k] = v - 1
            end
        end
    end
end)

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if tora[user_id] == 0 or not tora[user_id] then
			if vRP.tryGetInventoryItem(user_id,"tora",quantidade[source]) then
				randmoney = (math.random(200,250)*quantidade[source])
		        vRP.giveMoney(user_id,parseInt(randmoney))
		        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
				quantidade[source] = nil
				emP.Quantidade()
				tora[user_id] = 15
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x Toras de Madeira</b>.")
			end
		else
			--SendWebhookMessage(webhookmonster,"```prolog\n[ID]: "..user_id.." \n[TENTOU USAR MONSTERMENU E FOI PEGO NO PULO]\n>>>> "..quantidade[source].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```<@&641048265856647169>")
			TriggerClientEvent("Notify",source,"importante","Você precisa aguardar <b>"..tora[user_id].." segundos</b> para realizar outra entrega.")
		end
	end
	return false
end

local roupas = {
	[1885233650] = {
		 [1] = { 36,0 }, -- Mascara
		 [3] = { 75,0 }, -- Maos
		 [4] = { 40,2 }, -- Calça
		 [5] = { -1,0 }, -- Mochila
		 [6] = { 24,0 }, -- Sapato
		 [7] = { -1,0 }, -- Acessorios			
		 [9] = { 0,0 }, -- Colete
		 [10] = { -1,0 }, -- Adesivo
		 [11] = { 67,2 }, -- Jaqueta
		 ["p0"] = { -1,0 }, -- Chapeu
	},
	[-1667301416] = {
	 [1] = { 36,0 }, -- Mascara
	 [3] = { 88,0 }, -- Maos
	 [4] = { 40,2 }, -- Calça
	 [5] = { -1,0,0 }, -- Mochila
	 [6] = { 24,0 }, -- Sapato
	 [7] = { -1,0,0 }, -- Acessorios			
	 [9] = { 0,0 }, -- Colete
	 [10] = { -1,0 }, -- Adesivo
	 [11] = { 61,2 }, -- Jaqueta
	 ["p0"] = { -1,0 }, -- Chapeu
	}
}
 
RegisterServerEvent("colocar-uniforme:madeira")
AddEventHandler("colocar-uniforme:madeira",function()
	local user_id = vRP.getUserId(source)
	local custom = roupas
	if custom then
		local old_custom = vRPclient.getCustomization(source)
		local idle_copy = {}

		idle_copy = vRP.save_idle_custom(source,old_custom)
		idle_copy.modelhash = nil

		for l,w in pairs(custom[old_custom.modelhash]) do
		 	idle_copy[l] = w
		end
		vRPclient._setCustomization(source,idle_copy)
	end
end)
 
 
RegisterServerEvent("tirar-uniforme:madeira")
AddEventHandler("tirar-uniforme:madeira",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)