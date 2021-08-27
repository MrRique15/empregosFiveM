local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local reward = {77,160}
local rndResult = math.random(1,1)

RegisterServerEvent('damn_lixeiro:rewardTrash')
AddEventHandler('damn_lixeiro:rewardTrash', function(farm)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)

	local x,y = table.unpack(reward)
	local rewardValue = math.random(x, y)
	vRP.giveMoney(user_id,rewardValue)
	TriggerClientEvent("Notify",source,"sucesso","Você recebeu R$"..rewardValue.."")
	Wait(10000)
end)

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
 
RegisterServerEvent("colocar-uniforme:lixeiro")
AddEventHandler("colocar-uniforme:lixeiro",function()
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
 
 
RegisterServerEvent("tirar-uniforme:lixeiro")
AddEventHandler("tirar-uniforme:lixeiro",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)