local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_racejet",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookcorrida = "https://discordapp.com/api/webhooks/683028423811137635/30km58utqjrn2RIrrTzX_epcRC9-vn74iNpW246QPKn1-8suJ9cyrCMG5jdap2GPlels"
local webhookcorridapagamento = "https://discordapp.com/api/webhooks/683028423811137635/30km58utqjrn2RIrrTzX_epcRC9-vn74iNpW246QPKn1-8suJ9cyrCMG5jdap2GPlels"
-- local webhookcorrida = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 2000, ['max'] = 2500, ['rtime'] = 1000, ['rid'] = 0 },
	[2] = { ['min'] = 1000, ['max'] = 1500, ['rtime'] = 1000, ['rid'] = 0 },
	[3] = { ['min'] = 1000, ['max'] = 1500, ['rtime'] = 1000, ['rid'] = 0 },
	[4] = { ['min'] = 1000, ['max'] = 2000, ['rtime'] = 1000, ['rid'] = 0 },
	[5] = { ['min'] = 800, ['max'] = 1300, ['rtime'] = 1000, ['rid'] = 0 },
	[6] = { ['min'] = 1000, ['max'] = 1500, ['rtime'] = 1000, ['rid'] = 0 },
	[7] = { ['min'] = 1100, ['max'] = 1600, ['rtime'] = 1000, ['rid'] = 0 },
	[8] = { ['min'] = 800, ['max'] = 1300, ['rtime'] = 1000, ['rid'] = 0 },
	[9] = { ['min'] = 1200, ['max'] = 1800, ['rtime'] = 1000, ['rid'] = 0 },
	[10] = { ['min'] = 2300, ['max'] = 3300, ['rtime'] = 1000, ['rid'] = 0 }
}
local racers = 0
local timer = 5
local segundos = 600

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO DE INÍCIO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timer > 0 then
			timer = timer - 1
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO DE DURAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 1 then
				racers = 0
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ VERIFICADOR
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkTimer()
	local source = source
	local segundos = segundos
	Citizen.Wait(1)
	if (timer > 0 and racers < 5) or (timer == 0 and racers == 0) then
		racers = racers + 1
		return true
	else
		-- TriggerClientEvent("Notify",source,"aviso","Existe uma corrida em andamento, tente novamente mais tarde.")
		TriggerClientEvent("Notify",source,"aviso","Existe uma corrida em andamento. A próxima corrida estará disponível em "..segundos.." segundos.")
		return false
	end
end]]

function emP.registerRecord(race, time)
	local source = source
	local user_id = vRP.getUserId(source)
	local name = ""
	if pay[race].rid ~= 0 then
		local identity = vRP.getUserIdentity(pay[race].rid)
		name = ""..identity.name.." "..identity.firstname..""
	end

	if user_id then
		if time < pay[race].rtime then
			TriggerClientEvent("Notify",source,"sucesso","Você bateu o record do dia nesta corrida! Parabéns!<br>Tempo: "..time.."s")
			if pay[race].rid ~= 0 then
				if pay[race].rid == user_id then
					TriggerClientEvent("Notify",source,"importante","Você bateu seu próprio record!<br>Tempo: "..time.."s")
				else
					TriggerClientEvent("Notify",source,"aviso","O record anterior era de <b>"..name.."</b>.<br>Record anterior: "..pay[race].rtime.."s")
				end
			end
			pay[race].rtime = time
			pay[race].rid = user_id
		else
			TriggerClientEvent("Notify",source,"importante","Você completou a corrida.<br>Seu tempo: "..time.."s", 2000)
			if pay[race].rid == user_id then
				TriggerClientEvent("Notify",source,"importante","O record desta corrida é seu!<br>Tempo recorde: "..pay[race].rtime.."s")
			else
				TriggerClientEvent("Notify",source,"aviso","O record desta corrida pertence a <b>"..name.."</b>.<br>Tempo recorde: "..pay[race].rtime.."s", 4000)
			end
		end
	end
end

function emP.paymentCheck(check,status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local random = math.random(pay[check].min,pay[check].max)
		local policia = vRP.getUsersByPermission("policia.permissao")
		local teto_pagamento = false
		
		if parseInt(#policia) == 0 then
			teto_pagamento = parseInt(random * status)
			print (status)
		else
			teto_pagamento = parseInt(random * math.ceil(parseInt(#policia) / 2) * status)
		end

		if teto_pagamento > 50000 then
			teto_pagamento = 50000
		end

		vRP.giveInventoryItem(user_id,"dinheirosujo",teto_pagamento)
	end
end

local racepoint = 1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(900000)
		racepoint = math.random(#pay)
	end
end)

function emP.getRacepoint()
	return parseInt(racepoint)
end

function emP.startBombRace()
	segundos = 600
	if racers == 1 then
		timer = 5
	end
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	SendWebhookMessage(webhookcorrida,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

	local policia = vRP.getUsersByPermission("policia.permissao")
	TriggerEvent('eblips:add',{ name = "Corredor", src = source, color = 83 })
	for l,w in pairs(policia) do
		local player = vRP.getUserSource(parseInt(w))
		if player then
			async(function()
				vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Denúncia de 10-94, intercepte o corredor!")
			end)
		end
	end
end

function emP.setSearchTimer()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.searchTimer(user_id,parseInt(900))
	end
end


function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then			
			return true		
		else
			return false
		end
	end	
end

--[[
function emP.checkPermission()
	return not (vRP.searchReturn(source,user_id))
	-- return true -- DEBUG
end]]

function emP.checkTicket()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.tryGetInventoryItem(user_id, "bilhete", 1) then
		return true
	else
		TriggerClientEvent("Notify",source, "negado", "Você precisa de um bilhete para iniciar a corrida.")
		return false
	end
end

RegisterCommand('recordes',function(source,rawCommand)
	local user_id = vRP.getUserId(source)
	local text = "<b>Recordes atuais:</b>"
	if not vRP.hasPermission(user_id,"policia.permissao") then
		for k,v in pairs(pay) do
			if v.rid ~= 0 then
				local identity = vRP.getUserIdentity(v.rid)
				text = text.."<br><br><b>Corrida "..k.."</b><br>Corredor: <b><i>"..identity.name.." "..identity.firstname.."<i></b><br>Tempo: <b>"..v.rtime.."s</b>"
			else
				text = text.."<br><br><b>Corrida "..k.."</b><br>Nenhuma corrida hoje."
			end
		end
		TriggerClientEvent("Notify",source,"importante", text, 2000)
	end
end)

RegisterCommand('unbomb',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent('emp_race:unbomb',nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Você desarmou a <b>Bomba</b> com sucesso.")
		end
	end
end)

function emP.removeBombRace()
	local source = source
	TriggerEvent('eblips:remove',source)
end