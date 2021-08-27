local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_caminhao",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local gas = 1
local cars = 1
local show = 1
local woods = 1
local diesel = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local paylist = {
	["diesel"] = {
		[1] = { pay = math.random(2300,3300) },
		[2] = { pay = math.random(2300,3300) },
		[3] = { pay = math.random(2300,3300) },
		[4] = { pay = math.random(2400,3800) },
		[5] = { pay = math.random(4000,5400) },
		[6] = { pay = math.random(2300,3300) }
	},
	["gas"] = {
		[1] = { pay = math.random(2500,3950) },
		[2] = { pay = math.random(1700,3100) },
		[3] = { pay = math.random(1700,3100) },
		[4] = { pay = math.random(900,2300) },
		[5] = { pay = math.random(550,1300) },
		[6] = { pay = math.random(1000,2400) },
		[7] = { pay = math.random(1700,3100) },
		[8] = { pay = math.random(550,1300) },
		[9] = { pay = math.random(900,2300) },
		[10] = { pay = math.random(2300,3300) },
		[11] = { pay = math.random(2300,3300) },
		[12] = { pay = math.random(2200,3100) }
	},
	["cars"] = {
		[1] = { pay = math.random(1300,2700) },
		[2] = { pay = math.random(1000,2400) },
		[3] = { pay = math.random(1300,2700) },
		[4] = { pay = math.random(900,2400) },
		[5] = { pay = math.random(2300,3300) },
		[6] = { pay = math.random(900,2300) }
	},
	["woods"] = {
		[1] = { pay = math.random(3500,4400) },
		[2] = { pay = math.random(2300,3700) },
		[3] = { pay = math.random(550,1300) },
		[4] = { pay = math.random(1300,2700) }
	},
	["show"] = {
		[1] = { pay = math.random(2300,3700) },
		[2] = { pay = math.random(1300,2700) },
		[3] = { pay = math.random(1700,3100) },
		[4] = { pay = math.random(550,1300) }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(id,mod,health)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveMoney(user_id,parseInt(paylist[mod][id].pay+(health-700)))
		TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>R$"..vRP.format(parseInt(paylist[mod][id].pay+(health-700))).." reais</b>.")
		if mod == "cars" then
			local value = vRP.getSData("meta:concessionaria")
			local metas = json.decode(value) or 0
			if metas then
				vRP.setSData("meta:concessionaria",json.encode(parseInt(metas+1)))
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		diesel = math.random(#paylist["diesel"])
		gas = math.random(#paylist["gas"])
		cars = math.random(#paylist["cars"])
		woods = math.random(#paylist["woods"])
		show = math.random(#paylist["show"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTRUCKPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.getTruckpoint(point)
	if point == "diesel" then
		return parseInt(math.random(1,6))
	elseif point == "gas" then
		return parseInt(math.random(1,12))
	elseif point == "cars" then
		return parseInt(math.random(1,6))
	elseif point == "woods" then
		return parseInt(math.random(1,4))
	elseif point == "show" then
		return parseInt(math.random(1,4))
	end
end