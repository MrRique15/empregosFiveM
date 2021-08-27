local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
srv = {}
Tunnel.bindInterface("jornal_coletar", srv)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function srv.imprimirJornais()
	local source = source
	local user_id = vRP.getUserId(source)
	local raw = "cartucho"
	local item = "jornal"
	local amount = 10
	if user_id then
		if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(item) * amount <= vRP.getInventoryMaxWeight(user_id) + vRP.getItemWeight(raw) then
			if vRP.tryGetInventoryItem(user_id, "cartucho", 1) then
				vRPclient._playAnim(source,true,{{"anim@treasurehunt@doubleaction@action", "double_action_pickup"}},false)
				vRP.giveInventoryItem(user_id, item, amount)
				TriggerClientEvent("Notify",source,"importante","Cartucho substituído.")
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa de cartucho.")
				return false
			end
		else
			TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
			return false
		end
	end
end

function srv.comprarCartucho()
	local src = source
	local user_id = vRP.getUserId(src)
	local item = "cartucho"
	local amount = 1
	local value = 50
	if user_id then
		if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(item) * amount <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.tryPayment(user_id, value) then
				vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
				vRP.giveInventoryItem(user_id, item, 1)
				TriggerClientEvent("Notify",source,"sucesso","Comprou um <b>cartucho</b> por <b>R$"..value.."</b>.")
				return true
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa de R$"..value.." para comprar um cartucho.")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Espaço insuficiente, "..vRP.getItemWeight(item) * amount.."kg necessário.")
		end
	end
end

function srv.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return true
end