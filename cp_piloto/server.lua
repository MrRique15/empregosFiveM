
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("cp_piloto",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"piloto.permissao")
end

function emP.checkPayment(payment)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randmoney = (math.random(500,1000)*payment)
        vRP.giveMoney(user_id,parseInt(randmoney))
        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
        TriggerClientEvent("Notify",source,"bom","<b>McKenzie:</b> Você recebeu <b>$"..randmoney.." dólares</b> pela viagem.",3000)
        TriggerClientEvent("Notify",source,"bom","<b>McKenzie:</b> Ei, ei, ei! Vá depressa buscar o próximo passageiro!",5000)
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
 
RegisterServerEvent("colocar-uniforme:cafetao")
AddEventHandler("colocar-uniforme:cafetao",function()
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
 
 
RegisterServerEvent("tirar-uniforme:cafetao")
AddEventHandler("tirar-uniforme:cafetao",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)