local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
heL = {}
Tunnel.bindInterface("high_taco",heL)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function heL.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = 5
	end
	   TriggerClientEvent("quantidade-lanche",source,parseInt(quantidade[source]))
end

function heL.checkPayment()
	heL.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"lanche",quantidade[source]) then
			randmoney = (math.random(100,200)*quantidade[source])
	        vRP.giveMoney(user_id,parseInt(randmoney))
	        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
	        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
			quantidade[source] = nil
			heL.Quantidade()
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de <b>"..quantidade[source].."x Lanches</b>.")
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function heL.checkLanche()
	local source = source
	local user_id = vRP.getUserId(source)
	
	if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("lanche")*5 <= vRP.getInventoryMaxWeight(user_id) then
		vRP.giveInventoryItem(user_id,"lanche",5)
		return true
	else
		TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
		return false
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
 
RegisterServerEvent("colocar-uniforme:taco")
AddEventHandler("colocar-uniforme:taco",function()
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
 
 
RegisterServerEvent("tirar-uniforme:taco")
AddEventHandler("tirar-uniforme:taco",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)