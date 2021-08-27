local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("instaladorInternet",emP)
Proxy.addInterface("instaladorInternet",emP)

valorMin = 90
valorMax = 350


-----------------------------------------------------------------------------------------------------------------------------------------



function emP.pagar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local pagamento = math.random(valorMin,valorMax)
		vRP.giveMoney(user_id,pagamento)
		return pagamento
	end
end


