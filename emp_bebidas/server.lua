local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface("emp_bebidas",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLOCAR ROUPA DO SERIVÇO
-----------------------------------------------------------------------------------------------------------------------------------------

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
 
RegisterServerEvent("colocar-uniforme:bebidas")
AddEventHandler("colocar-uniforme:bebidas",function()
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
 
 
RegisterServerEvent("tirar-uniforme:bebidas")
AddEventHandler("tirar-uniforme:bebidas",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

function func.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	-- return vRP.hasPermission(user_id,perm)
	return true
end

function func.checkPermissions()
	local source = source
	local user_id = vRP.getUserId(source)
	-- if vRP.hasPermission(user_id, 'bahamas.permissao') or vRP.hasPermission(user_id, 'tequilala.permissao') or vRP.hasPermission(user_id, 'vanilla.permissao') then
	-- 	return true
	-- else
	-- 	return false
	-- end
	return true
end

requisitos = {}
requisitos['coquetelvanilla'] = {
	[0] = { ['nome'] = 'vodka', ['qtd'] = 1 },
	[1] = { ['nome'] = 'morango', ['qtd'] = 3 },
}

requisitos['coquetelbahamas'] = {
	[0] = { ['nome'] = 'whisky', ['qtd'] = 1 },
	[1] = { ['nome'] = 'laranja', ['qtd'] = 3 },
}

requisitos['coqueteltequilala'] = {
	[0] = { ['nome'] = 'tequila', ['qtd'] = 1 },
	[1] = { ['nome'] = 'limao', ['qtd'] = 3 },
}

function func.colher(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local amount = math.random(1,3)
	if user_id then
		if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(item) * amount <= vRP.getInventoryMaxWeight(user_id) then
			vRPclient._playAnim(source, false,{{"anim@am_hold_up@female","shoplift_high"}}, true)
			Citizen.Wait(4500)
			vRPclient._stopAnim(source,false)
			TriggerClientEvent("Notify",source,"sucesso","Você colheu <b>"..amount.."x "..item.."</b>.")
			vRP.giveInventoryItem(user_id, item, amount)
		else
			TriggerClientEvent("Notify",source,"negado","Você não consegue carregar mais <b>"..item.."</b>!")
		end
	end
end

function func.processar(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local req = false
	if user_id then
		for i = 0, 1 do
			if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(requisitos[item][i].nome) * requisitos[item][i].qtd <= vRP.getInventoryMaxWeight(user_id) then
				req = true
			else
				TriggerClientEvent("Notify",source,"negado","Você não consegue carregar mais <b>"..item..".")
				req = false
				break
			end
		end

		if req == true then
			local drink = true
			vRPclient._playAnim(source, false,{{"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator"}}, true)
			for i = 0, 1 do
				if vRP.tryGetInventoryItem(user_id, requisitos[item][i].nome, requisitos[item][i].qtd) then
					TriggerClientEvent("Notify",source,"importante","Processando <b>" .. requisitos[item][i].nome .. "</b>.")
					Citizen.Wait(3000)
				else
					TriggerClientEvent("Notify",source,"negado","Você não possui <b>" .. requisitos[item][i].nome .. "</b>.")
					drink = false
				end
			end
			if drink == true then
				TriggerClientEvent("Notify",source,"importante","Coquetel produzido!")
				vRP.giveInventoryItem(user_id, item, 1)
				Citizen.Wait(2000)
			end
			Citizen.Wait(1)
			vRPclient._stopAnim(source,false)
		end
	end
end

function func.entregar(distance, product)
	local source = source
	local user_id = vRP.getUserId(source)
	local metervalue = 0.5
	local amount = math.random(1,2)
	local money = math.ceil(distance * metervalue) * amount
	if user_id then
		if vRP.tryGetInventoryItem(user_id, product, amount) then
			TriggerClientEvent("Notify",source,"sucesso","Você entregou "..amount.." coquetéis.<br>Lucro da entrega: <b>R$"..money.."")
			vRP.giveMoney(user_id, money)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui coquetéis o suficiente!")
			return false
		end
	end
end