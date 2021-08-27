local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
    { item = "fotografia", venda = 250 },
    { item = "otima-fotografia", venda = 500 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("fotos-vender")
AddEventHandler("fotos-vender",function(item)
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
                        TriggerClientEvent("Notify",source,"sucesso","Sucesso", "Vendeu <b>"..quantidade.."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.venda*quantidade)).." reais</b>.<br> Continue tirando fotos para ficar rico!")
                    end
                else
                    TriggerClientEvent("Notify",source,"negado","Negado", "Não possui <b>"..vRP.itemNameList(v.item).."</b> em sua mochila.")
                end
            end
        end
    end
end)
