local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
srv = {}
Tunnel.bindInterface("jornal_entregas", srv)

RegisterServerEvent('jornal_entregas:itensReceber')
AddEventHandler('jornal_entregas:itensReceber', function(distance)
	if distance > 4000 then
		distance = 4000
	end

	local src = source
	local user_id = vRP.getUserId(src)
	local metervalue = 0.3
	local money = math.ceil(distance * metervalue)
	local amount = 1
	-- local money = math.random(200,300)
	if user_id and vRP.hasPermission(user_id, "news.permissao") then
		if vRP.tryGetInventoryItem(user_id, "jornal", amount, true) then
			vRPclient._playAnim(source, true, {{"anim@am_hold_up@female","shoplift_low"}}, false)
			vRPclient._DeletarObjeto(source)
			-- print('Pagando: ' .. money .. ' | para: ' .. user_id .. ' | pela distancia: ' .. distance .. ' | dol/dist:' .. (money/distance))
			vRP.giveMoney(user_id, money)
			TriggerClientEvent("Notify",source,"sucesso", amount.." jornal entregue!<br><b>R$"..money * amount.." recebido.</b>")
			SetTimeout(5000,function()
				vRPclient.removeDiv(src, "Alerta")
			end)
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..amount.." jornal</b>.")
		end
	end
end)

-------------------------------------------------------------------------------
-- FUNÇÕES
-------------------------------------------------------------------------------
function srv.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id, "news.permissao")
end