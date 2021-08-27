-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = {}
Tunnel.bindInterface("emp_advogado",emP)
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
   local valor = math.random(200,250)*quantidade[source]
   if user_id then
      if vRP.tryGetInventoryItem(user_id,"document",quantidade[source]) then
         vRP.giveMoney(user_id,valor)
         TriggerClientEvent("Notify",source,"sucesso","<b>Você Recebeu U$"..valor.."Dólares </b>")
         quantidade[source] = nil
         return true
      else
         TriggerClientEvent("Notify",source,"negado","<b>Você Não Tem Processos Suficiente</b>.")
      end
   end
end
