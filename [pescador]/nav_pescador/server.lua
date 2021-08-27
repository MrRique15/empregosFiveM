local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "dourado", venda = 240 },
	{ item = "corvina", venda = 270 },
	{ item = "salmao", venda = 230 },
	{ item = "pacu", venda = 210 },
	{ item = "pintado", venda = 190 },
	{ item = "pirarucu", venda = 240 },
	{ item = "tilapia", venda = 200 },
	{ item = "tucunare", venda = 210 },
	{ item = "lambari", venda = 700 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("pescador-vender")
AddEventHandler("pescador-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	local quantidade = 0
	if data and data.inventory then
		for k,v in pairs(valores) do
			if item == v.item then
				for i,o in pairs(data.inventory) do
					if i == item then
						quantidade = o.amount
					end
				end
				if parseInt(quantidade) > 0 then
					if vRP.tryGetInventoryItem(user_id,v.item,quantidade) then
						vRP.giveMoney(user_id,parseInt(v.venda*quantidade))
						TriggerClientEvent("Notify",source,"sucesso","Vendeu com sucesso!")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Não possui esse peixe em sua mochila.")
				end
			end
		end
	end
end)