local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
srv = {}
Tunnel.bindInterface("emp_bombeiros", srv)

RegisterServerEvent('emp_bombeiros:reparar')
AddEventHandler('emp_bombeiros:reparar', function(distance)
	if distance > 4000 then
		distance = 4000
	end

	local src = source
	local user_id = vRP.getUserId(src)

	local metervalue = 0.25
	local money = math.ceil(distance * metervalue)

	-- Checa permissão, inicia o reparo e efetua o pagamento
	if user_id and vRP.hasPermission(user_id, "manager.permissao") then
		vRPclient._playAnim(src, false, {{"amb@prop_human_bum_bin@idle_a","idle_a"}}, true)
		vRP.giveMoney(user_id, money)
		TriggerClientEvent("Notify",src, "importante", "Reparando hidrante...<br>")
		SetTimeout(8000,function()
			vRPclient.removeDiv(src, "Alerta")
			TriggerClientEvent("Notify",src,"sucesso", "<b>R$"..money.." recebido.</b>")
		end)
	end
end)

-------------------------------------------------------------------------------
-- FUNÇÕES
-------------------------------------------------------------------------------
function srv.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	-- return vRP.hasPermission(user_id, "manager.permissao")
	return true
end

function srv.getEquips()
	local source = source
	local user_id = vRP.getUserId(source)
	vRPclient.giveWeapons(source,{["WEAPON_FLASHLIGHT"] = { ammo = 0 }})
	vRPclient.giveWeapons(source,{["WEAPON_FIREEXTINGUISHER"] = { ammo = 0 }})
	vRPclient.giveWeapons(source,{["WEAPON_HATCHET"] = { ammo = 0 }})
	TriggerClientEvent("Notify",source,"sucesso","Você pegou a lanterna e o extintor.")		
end

function srv.clearEquips()
	local source = source
	local user_id = vRP.getUserId(source)
	vRPclient.giveWeapons(source,{},true)
	TriggerClientEvent("Notify",source,"importante","Você guardou todos os equipamentos.")		
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
 
RegisterServerEvent("colocar-uniforme:bombeiro")
AddEventHandler("colocar-uniforme:bombeiro",function()
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
 
 
RegisterServerEvent("tirar-uniforme:bombeiro")
AddEventHandler("tirar-uniforme:bombeiro",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)