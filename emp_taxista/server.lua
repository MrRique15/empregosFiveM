local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_taxista",emP)
local taxiMeter = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.addGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.addUserGroup(user_id,"taxista")
end

function emP.removeGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.removeUserGroup(user_id,"taxista")
end

function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"taxista.permissao")
end

function emP.checkPayment(payment)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randmoney = (math.random(40,70)*payment)
        vRP.giveMoney(user_id,parseInt(randmoney))
        TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
        TriggerClientEvent("Notify",source,"bom","Você recebeu <b>$"..randmoney.." dólares</b>.")
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
 
RegisterServerEvent("colocar-uniforme:taxista")
AddEventHandler("colocar-uniforme:taxista",function()
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
 
 
RegisterServerEvent("tirar-uniforme:taxista")
AddEventHandler("tirar-uniforme:taxista",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES DO TAXIMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.3) / mult
end

function splitString(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end