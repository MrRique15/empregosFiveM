-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("advogado_coleta",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
   local source = source
   local user_id = vRP.getUserId(source)
   return vRP.hasPermission(user_id,"advogado.permissao")
end

local quantidade = {}
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(3,5)
   end
end

function emP.checkPayment()
   emP.Quantidade()
   local source = source
   local user_id = vRP.getUserId(source)
   if user_id then
      if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("document")<= vRP.getInventoryMaxWeight(user_id) then
         vRP.giveInventoryItem(user_id,"document",quantidade[source])
         TriggerClientEvent("Notify",source,"sucesso","<b>Você Coletou "..quantidade[source].."x Pasta de Processos</b>")
         quantidade[source] = nil
         return true
      else
         TriggerClientEvent("Notify",source,"negado","<b>Inventário Cheio</b>.")
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
 
RegisterServerEvent("colocar-uniforme:adv")
AddEventHandler("colocar-uniforme:adv",function()
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
 
 
RegisterServerEvent("tirar-uniforme:adv")
AddEventHandler("tirar-uniforme:adv",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)
