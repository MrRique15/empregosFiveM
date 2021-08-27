local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
ifood = {}
Tunnel.bindInterface("ifood",ifood)

function ifood.pagar(distancia)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
	local pagamento = distancia * 0.1
        pagamento = pagamento / 0.20 

		vRP.giveMoney(user_id,math.floor(pagamento)) 
		return pagamento
	end
end

function ifood.teleport(x,y,z)
	local source = source

 	vRPclient.teleport(source,x,y,z)
end

RegisterServerEvent("trydeleteveh")
AddEventHandler("trydeleteveh",function(index)
	TriggerClientEvent("syncdeleteveh",-1,index)
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
 
RegisterServerEvent("colocar-uniforme:ifood")
AddEventHandler("colocar-uniforme:ifood",function()
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
 
 
RegisterServerEvent("tirar-uniforme:ifood")
AddEventHandler("tirar-uniforme:ifood",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)