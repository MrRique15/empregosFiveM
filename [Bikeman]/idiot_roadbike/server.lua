local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
job = {}
Tunnel.bindInterface("idiot_roadbike",job)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇOES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('idiot_roadbike:permissao')
AddEventHandler('idiot_roadbike:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('idiot_roadbike:permissao',player)
end)

function job.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	local chance = math.random(0,100)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("otima-fotografia")+vRP.getItemWeight("fotografia") <= vRP.getInventoryMaxWeight(user_id) then
			chance = math.random(0,100)
			if chance >= 0  and chance <= 19 then 
				vRP.giveInventoryItem(user_id,"otima-fotografia",1)
			elseif chance >= 20 and chance <= 100 then 
				vRP.giveInventoryItem(user_id,"fotografia",1)
		
				return true
			end
		else
			TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
		end
	end
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
 
RegisterServerEvent("colocar-uniforme:fotos")
AddEventHandler("colocar-uniforme:fotos",function()
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
 
 
RegisterServerEvent("tirar-uniforme:fotos")
AddEventHandler("tirar-uniforme:fotos",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)