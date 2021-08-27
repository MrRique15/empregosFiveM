local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
emp = {}
Tunnel.bindInterface("emp_caminhao",emp)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emp.EntregarItens(porcentagem)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local pagamento = math.random(500,3500)
		vRP.giveMoney(user_id,parseInt(pagamento))
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." dólares</b>.")
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
 
RegisterServerEvent("colocar-uniforme:arsenal")
AddEventHandler("colocar-uniforme:arsenal",function()
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
 
 
RegisterServerEvent("tirar-uniforme:arsenal")
AddEventHandler("tirar-uniforme:arsenal",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)