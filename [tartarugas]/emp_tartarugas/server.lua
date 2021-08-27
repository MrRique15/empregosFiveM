local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_tartarugas",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
function emP.Quantidadetartarugas()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(2,4)
	end
end

function emP.checkFrutas()
	emP.Quantidadetartarugas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("tartaruga")*quantidade[source] <= vRP.getInventoryMaxWeight(user_id) then
			TriggerClientEvent("Notify",source,"sucesso","Você pegou <b>"..quantidade[source].."</b> Tartarugas.") 
			vRP.giveInventoryItem(user_id,"tartaruga",quantidade[source])
			quantidade[source] = nil
			return true
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.")
			return false
		end
	end
end

function emP.checkPaymenttart()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("tartaruga")*3 <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,"tartaruga",3,false) then
					vRP.giveInventoryItem(user_id,"carnedetartaruga",3,false)
					return true
				end
			end
	end
end