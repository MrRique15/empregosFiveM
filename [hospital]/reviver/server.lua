local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface("reviver",func)

local cobrar = true
local valorAtendimento = 500
finalizados = {}

function func.checkParamedico()
local samu = vRP.getUsersByPermission("samu.permissao")

if #samu == 0 then
 
return true
end
end


RegisterServerEvent("verificaSamu")
AddEventHandler(
    "verificaSamu",
    function()

local samu = vRP.getUsersByPermission("paramedico.permissao")
local source = source
        local player = vRP.getUserId(source)
if #samu == 0 then
TriggerClientEvent("SemSamu", source)
else
 TriggerClientEvent("comSamu", source)
end

end)


RegisterServerEvent("Reviver:reviver")
AddEventHandler(
    "Reviver:reviver",
    function()

        local source = source
        local player = vRP.getUserId(source)
        local perguntaSamu = vRP.request(source, "Você deseja chamar o samu? Não pode ser usado em Ação!", 60)
        if perguntaSamu and not finalizados[player] then
            local source = vRP.getUserSource(player)
            if cobrar then
                if vRP.tryPayment(player, valorAtendimento) then
                    TriggerClientEvent("revive:NPCeAMBULANCIA", source)
                    TriggerClientEvent("Notify", source, "Sucesso", "Você pagou R$" ..valorAtendimento.. " Pelo atendimento. Aguarde o Samu de plantão no local!")
                end
            else
                TriggerClientEvent("revive:NPCeAMBULANCIA", source)
                TriggerClientEvent("Notify", source, "aviso", "Aguarde o Samu de plantão no local!")
            end
        end
    end
)

RegisterServerEvent("reviver:Player")
AddEventHandler(
    "reviver:Player",
    function()
   local user_id = vRP.getUserId(source)
	
			vRPclient.killGod(source)
			vRPclient.setHealth(source,200)
    TriggerClientEvent("fecharGui", source)

    end
)