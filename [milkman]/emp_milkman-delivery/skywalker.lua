local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

emp = {}
Tunnel.bindInterface("vrp_milkman-delivery",emp)

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local amount = {}

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function emp.startPayments()
	local source = source

	if amount[source] == nil then
		amount[source] = math.random(3,6)
	end

	local user_id = vRP.getUserId(source)
	if user_id then
	
		local data = vRP.getUserAptitudes(user_id)
		if data then
			if vRP.tryGetInventoryItem(user_id,"garrafa-leite",amount[source]) then
				local price = math.random(150,220)

				vRP.giveDinheirama(user_id,parseInt(price*amount[source]))
				TriggerClientEvent("vrp_sound:source",source,'coin',0.2)
				TriggerClientEvent("Notify",source,"sucesso","Entrega concluída, recebido <b>$"..vRP.format(parseInt(price*amount[source])).." dólares</b>.",8000)

				amount[source] = nil
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount[source].."x Garrafas de Leite</b>.",8000)
			end
		end
		return false
	end
end

function emp.checkPlate(modelo)
	local source = source
	local user_id = vRP.getUserId(source)
	local veh,vhash,vplaca,vname = vRPclient.vehListHash(source,4)
	if veh and vhash == modelo then
		local placa_user_id = vRP.getUserByRegistration(vplaca)
		if user_id == placa_user_id then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você <b>precisa usar o carro</b> de serviço.",10000)
			return false
		end
	end
end

function emp.checkCrimeRecord()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.checkCrimeRecord(user_id) > 0 then
			TriggerClientEvent("Notify",source,"negado","Não contratamos pessoas com <b>Ficha Criminal</b>.",10000)
			return false
		else
			return true
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
 
RegisterServerEvent("colocar-uniforme:leite")
AddEventHandler("colocar-uniforme:leite",function()
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
 
 
RegisterServerEvent("tirar-uniforme:leite")
AddEventHandler("tirar-uniforme:leite",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)