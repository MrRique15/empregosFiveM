local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local dsLiberado = false

RegisterCommand('liberararsenal',function(source,args,rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"manager.permissao") and dsLiberado == false then
	    dsLiberado = true
	    TriggerClientEvent('chatMessage',-1,"^9 [PREFEITURA] A Prefeitura Liberou a Missão de Arsenal para a Policia de Elysium.")
	else 
	    dsLiberado = false
	    TriggerClientEvent('chatMessage',-1,"^9 [PREFEITURA] A Prefeitura de Elysium Fechou a Missão de Carregamento .")
	end
end)

RegisterCommand('rotaarsenal',function(source,args,rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
	if dsLiberado == true then
	    if vRP.hasPermission(user_id,"dpla.permissao") then 
		    TriggerClientEvent('DonSpeed:InicioRotaPM', source)
		end
		if vRP.hasPermission(user_id,"policia.permissao") then 
			TriggerClientEvent('DonSpeed:InicioRotaROTA', source)
		end
	else 
	    TriggerClientEvent("Notify",source,"negado","Não tem permissao ou esta bloqueado .")
	end
end)

local NameVeh = nil

RegisterServerEvent('DonSpeed:Carregando')
AddEventHandler('DonSpeed:Carregando', function()
    local source = source
	local user_id = vRP.getUserId(source)
	
	local mPlaca,mName,mNet,mPrice,mBanido,mLock,mModel,mStreet = vRPclient.ModelName(source,7)
	local placa_user = vRP.getUserByRegistration(mPlaca)
	local identity = vRP.getUserIdentity(placa_user)
	
	local mala = "chest:u"..parseInt(user_id).."veh_"..mModel
	local data = vRP.getSData(mala)
	local items = json.decode(data) or {}
	
	NameVeh = mala
	
	items["wbody|WEAPON_COMBATPISTOL"] = { amount = parseInt(10) } 
	items["wbody|WEAPON_CARBINERIFLE"] = { amount = parseInt(10) } 
	items["wbody|WEAPON_SPECIALCARBINE"] = { amount = parseInt(10) }
	items["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(10) } 
	items["wbody|WEAPON_NIGHTSTICK"] = { amount = parseInt(10) } 
	items["wbody|WEAPON_FLASHLIGHT"] = { amount = parseInt(10) } 
	items["wbody|WEAPON_STUNGUN"] = { amount = parseInt(10) }
	items["colete"] = { amount = parseInt(10) }
	
	items["wammo|WEAPON_COMBATPISTOL"] = { amount = parseInt(100) } 
	items["wammo|WEAPON_CARBINERIFLE"] = { amount = parseInt(100) } 
	items["wammo|WEAPON_SPECIALCARBINE"] = { amount = parseInt(100) }
	items["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(100) } 
	items["wammo|WEAPON_STUNGUN"] = { amount = parseInt(10) }
	vRP.setSData(NameVeh,json.encode(items))
	
end)

local GuardarValor = {}

RegisterServerEvent('DonSpeed:Descarregando')
AddEventHandler('DonSpeed:Descarregando', function()
    local source = source
	local user_id = vRP.getUserId(source)
	
	local mPlaca,mName,mNet,mPrice,mBanido,mLock,mModel,mStreet = vRPclient.ModelName(source,7)
	local placa_user = vRP.getUserByRegistration(mPlaca)
	local identity = vRP.getUserIdentity(placa_user)
	
	local mala = "chest:u"..parseInt(user_id).."veh_"..mModel
	local data = vRP.getSData(mala)
	local items = json.decode(data) or {}
	
	NameVeh = mala
	
	GuardarValor[1] = parseInt(items["wbody|WEAPON_COMBATPISTOL"].amount)
	items["wbody|WEAPON_COMBATPISTOL"].amount = nil
	items["wbody|WEAPON_COMBATPISTOL"] = nil 

    GuardarValor[2] = parseInt(items["wbody|WEAPON_CARBINERIFLE"].amount)
	items["wbody|WEAPON_CARBINERIFLE"].amount = nil
	items["wbody|WEAPON_CARBINERIFLE"] = nil 
	
	GuardarValor[3] = parseInt(items["wbody|WEAPON_SPECIALCARBINE"].amount)
	items["wbody|WEAPON_SPECIALCARBINE"].amount = nil
	items["wbody|WEAPON_SPECIALCARBINE"] = nil 
	
	GuardarValor[4] = parseInt(items["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount)
	items["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount = nil
	items["wbody|WEAPON_PUMPSHOTGUN_MK2"] = nil 
	
	GuardarValor[5] = parseInt(items["wbody|WEAPON_NIGHTSTICK"].amount)
	items["wbody|WEAPON_NIGHTSTICK"].amount = nil
	items["wbody|WEAPON_NIGHTSTICK"] = nil
	
	GuardarValor[6] = parseInt(items["wbody|WEAPON_FLASHLIGHT"].amount)
	items["wbody|WEAPON_FLASHLIGHT"].amount = nil
	items["wbody|WEAPON_FLASHLIGHT"] = nil
	
	GuardarValor[7] = parseInt(items["wbody|WEAPON_STUNGUN"].amount)
	items["wbody|WEAPON_STUNGUN"].amount = nil
	items["wbody|WEAPON_STUNGUN"] = nil
	
	GuardarValor[8] = parseInt(items["wammo|WEAPON_COMBATPISTOL"].amount)
	items["wammo|WEAPON_COMBATPISTOL"].amount = nil
	items["wammo|WEAPON_COMBATPISTOL"] = nil 

    GuardarValor[9] = parseInt(items["wammo|WEAPON_CARBINERIFLE"].amount)
	items["wammo|WEAPON_CARBINERIFLE"].amount = nil
	items["wammo|WEAPON_CARBINERIFLE"] = nil 
	
	GuardarValor[10] = parseInt(items["wammo|WEAPON_SPECIALCARBINE"].amount)
	items["wammo|WEAPON_SPECIALCARBINE"].amount = nil
	items["wammo|WEAPON_SPECIALCARBINE"] = nil 
	
	GuardarValor[11] = parseInt(items["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount)
	items["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount = nil
	items["wammo|WEAPON_PUMPSHOTGUN_MK2"] = nil 
	
	GuardarValor[12] = parseInt(items["wammo|WEAPON_STUNGUN"].amount)
	items["wammo|WEAPON_STUNGUN"].amount = nil
	items["wammo|WEAPON_STUNGUN"] = nil

	GuardarValor[13] = parseInt(items["colete"].amount)
	items["colete"].amount = nil
	items["colete"] = nil

    vRP.setSData(NameVeh,json.encode(items))
	
    TriggerClientEvent("Notify",source,"sucesso","Descarregou com sucesso")

    if vRP.hasPermission(user_id,"dpla.permissao") then 
	    local sasadata = vRP.getSData("chest:"..tostring("static:1"))
	    local dsitems = json.decode(sasadata) or {}
        if dsitems["wbody|WEAPON_COMBATPISTOL"] == nil then
			dsitems["wbody|WEAPON_COMBATPISTOL"] = { amount = parseInt(GuardarValor[1]) } 
		else
			dsitems["wbody|WEAPON_COMBATPISTOL"].amount = dsitems["wbody|WEAPON_COMBATPISTOL"].amount + GuardarValor[1]
		end
		if dsitems["wbody|WEAPON_CARBINERIFLE"] == nil then
			dsitems["wbody|WEAPON_CARBINERIFLE"] = { amount = parseInt(GuardarValor[2]) } 
		else
			dsitems["wbody|WEAPON_CARBINERIFLE"].amount = dsitems["wbody|WEAPON_CARBINERIFLE"].amount + GuardarValor[2]
		end
		if dsitems["wbody|WEAPON_SPECIALCARBINE"] == nil then
			dsitems["wbody|WEAPON_SPECIALCARBINE"] = { amount = parseInt(GuardarValor[3]) } 
		else
			dsitems["wbody|WEAPON_SPECIALCARBINE"].amount = dsitems["wbody|WEAPON_SPECIALCARBINE"].amount + GuardarValor[3]
		end
		if dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"] == nil then
			dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(GuardarValor[4]) } 
		else
			dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount = dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount + GuardarValor[4]
		end
		if dsitems["wbody|WEAPON_NIGHTSTICK"] == nil then
			dsitems["wbody|WEAPON_NIGHTSTICK"] = { amount = parseInt(GuardarValor[5]) } 
		else
			dsitems["wbody|WEAPON_NIGHTSTICK"].amount = dsitems["wbody|WEAPON_NIGHTSTICK"].amount + GuardarValor[5]
		end
		if dsitems["wbody|WEAPON_FLASHLIGHT"] == nil then
			dsitems["wbody|WEAPON_FLASHLIGHT"] = { amount = parseInt(GuardarValor[6]) } 
		else
			dsitems["wbody|WEAPON_FLASHLIGHT"].amount = dsitems["wbody|WEAPON_FLASHLIGHT"].amount + GuardarValor[6]
		end
		if dsitems["wbody|WEAPON_STUNGUN"] == nil then
			dsitems["wbody|WEAPON_STUNGUN"] = { amount = parseInt(GuardarValor[7]) } 
		else
			dsitems["wbody|WEAPON_STUNGUN"].amount = dsitems["wbody|WEAPON_STUNGUN"].amount + GuardarValor[7]
		end
		if dsitems["colete"] == nil then
			dsitems["colete"] = { amount = parseInt(GuardarValor[13]) } 
		else
			dsitems["colete"].amount = dsitems["colete"].amount + GuardarValor[13]
		end
		
		
		if dsitems["wammo|WEAPON_COMBATPISTOL"] == nil then
			dsitems["wammo|WEAPON_COMBATPISTOL"] = { amount = parseInt(GuardarValor[8]) } 
		else
			dsitems["wammo|WEAPON_COMBATPISTOL"].amount = dsitems["wammo|WEAPON_COMBATPISTOL"].amount + GuardarValor[8]
		end
		if dsitems["wammo|WEAPON_CARBINERIFLE"] == nil then
			dsitems["wammo|WEAPON_CARBINERIFLE"] = { amount = parseInt(GuardarValor[9]) } 
		else
			dsitems["wammo|WEAPON_CARBINERIFLE"].amount = dsitems["wammo|WEAPON_CARBINERIFLE"].amount + GuardarValor[9]
		end
		if dsitems["wammo|WEAPON_SPECIALCARBINE"] == nil then
			dsitems["wammo|WEAPON_SPECIALCARBINE"] = { amount = parseInt(GuardarValor[10]) } 
		else
			dsitems["wammo|WEAPON_SPECIALCARBINE"].amount = dsitems["wammo|WEAPON_SPECIALCARBINE"].amount + GuardarValor[10]
		end
		if dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"] == nil then
			dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(GuardarValor[11]) } 
		else
			dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount = dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount + GuardarValor[11]
		end
		if dsitems["wammo|WEAPON_STUNGUN"] == nil then
			dsitems["wammo|WEAPON_STUNGUN"] = { amount = parseInt(GuardarValor[12]) } 
		else
			dsitems["wammo|WEAPON_STUNGUN"].amount = dsitems["wammo|WEAPON_STUNGUN"].amount + GuardarValor[12]
		end
        vRP.setSData("chest:"..tostring("static:1"),json.encode(dsitems))
        GuardarValor[1] = nil
		GuardarValor[2] = nil
		GuardarValor[3] = nil
		GuardarValor[4] = nil
		GuardarValor[5] = nil
		GuardarValor[6] = nil
		GuardarValor[7] = nil
		GuardarValor[8] = nil
		GuardarValor[9] = nil
		GuardarValor[10] = nil
		GuardarValor[11] = nil
		GuardarValor[12] = nil
		GuardarValor[13] = nil
		NameVeh = nil
    end
	if vRP.hasPermission(user_id,"policia.permissao") then 
	    local sasadata = vRP.getSData("chest:"..tostring("static:2"))
	    local dsitems = json.decode(sasadata) or {}
        if dsitems["wbody|WEAPON_COMBATPISTOL"] == nil then
			dsitems["wbody|WEAPON_COMBATPISTOL"] = { amount = parseInt(GuardarValor[1]) } 
		else
			dsitems["wbody|WEAPON_COMBATPISTOL"].amount = dsitems["wbody|WEAPON_COMBATPISTOL"].amount + GuardarValor[1]
		end
		if dsitems["wbody|WEAPON_CARBINERIFLE"] == nil then
			dsitems["wbody|WEAPON_CARBINERIFLE"] = { amount = parseInt(GuardarValor[2]) } 
		else
			dsitems["wbody|WEAPON_CARBINERIFLE"].amount = dsitems["wbody|WEAPON_CARBINERIFLE"].amount + GuardarValor[2]
		end
		if dsitems["wbody|WEAPON_SPECIALCARBINE"] == nil then
			dsitems["wbody|WEAPON_SPECIALCARBINE"] = { amount = parseInt(GuardarValor[3]) } 
		else
			dsitems["wbody|WEAPON_SPECIALCARBINE"].amount = dsitems["wbody|WEAPON_SPECIALCARBINE"].amount + GuardarValor[3]
		end
		if dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"] == nil then
			dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(GuardarValor[4]) } 
		else
			dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount = dsitems["wbody|WEAPON_PUMPSHOTGUN_MK2"].amount + GuardarValor[4]
		end
		if dsitems["wbody|WEAPON_NIGHTSTICK"] == nil then
			dsitems["wbody|WEAPON_NIGHTSTICK"] = { amount = parseInt(GuardarValor[5]) } 
		else
			dsitems["wbody|WEAPON_NIGHTSTICK"].amount = dsitems["wbody|WEAPON_NIGHTSTICK"].amount + GuardarValor[5]
		end
		if dsitems["wbody|WEAPON_FLASHLIGHT"] == nil then
			dsitems["wbody|WEAPON_FLASHLIGHT"] = { amount = parseInt(GuardarValor[6]) } 
		else
			dsitems["wbody|WEAPON_FLASHLIGHT"].amount = dsitems["wbody|WEAPON_FLASHLIGHT"].amount + GuardarValor[6]
		end
		if dsitems["wbody|WEAPON_STUNGUN"] == nil then
			dsitems["wbody|WEAPON_STUNGUN"] = { amount = parseInt(GuardarValor[7]) } 
		else
			dsitems["wbody|WEAPON_STUNGUN"].amount = dsitems["wbody|WEAPON_STUNGUN"].amount + GuardarValor[7]
		end
		if dsitems["colete"] == nil then
			dsitems["colete"] = { amount = parseInt(GuardarValor[13]) } 
		else
			dsitems["colete"].amount = dsitems["colete"].amount + GuardarValor[13]
		end
		
		
		if dsitems["wammo|WEAPON_COMBATPISTOL"] == nil then
			dsitems["wammo|WEAPON_COMBATPISTOL"] = { amount = parseInt(GuardarValor[8]) } 
		else
			dsitems["wammo|WEAPON_COMBATPISTOL"].amount = dsitems["wammo|WEAPON_COMBATPISTOL"].amount + GuardarValor[8]
		end
		if dsitems["wammo|WEAPON_CARBINERIFLE"] == nil then
			dsitems["wammo|WEAPON_CARBINERIFLE"] = { amount = parseInt(GuardarValor[9]) } 
		else
			dsitems["wammo|WEAPON_CARBINERIFLE"].amount = dsitems["wammo|WEAPON_CARBINERIFLE"].amount + GuardarValor[9]
		end
		if dsitems["wammo|WEAPON_SPECIALCARBINE"] == nil then
			dsitems["wammo|WEAPON_SPECIALCARBINE"] = { amount = parseInt(GuardarValor[10]) } 
		else
			dsitems["wammo|WEAPON_SPECIALCARBINE"].amount = dsitems["wammo|WEAPON_SPECIALCARBINE"].amount + GuardarValor[10]
		end
		if dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"] == nil then
			dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { amount = parseInt(GuardarValor[11]) } 
		else
			dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount = dsitems["wammo|WEAPON_PUMPSHOTGUN_MK2"].amount + GuardarValor[11]
		end
		if dsitems["wammo|WEAPON_STUNGUN"] == nil then
			dsitems["wammo|WEAPON_STUNGUN"] = { amount = parseInt(GuardarValor[12]) } 
		else
			dsitems["wammo|WEAPON_STUNGUN"].amount = dsitems["wammo|WEAPON_STUNGUN"].amount + GuardarValor[12]
		end
        vRP.setSData("chest:"..tostring("static:2"),json.encode(dsitems))
        GuardarValor[1] = nil
		GuardarValor[2] = nil
		GuardarValor[3] = nil
		GuardarValor[4] = nil
		GuardarValor[5] = nil
		GuardarValor[6] = nil
		GuardarValor[7] = nil
		GuardarValor[8] = nil
		GuardarValor[9] = nil
		GuardarValor[10] = nil
		GuardarValor[11] = nil
		GuardarValor[12] = nil
		GuardarValor[13] = nil
		NameVeh = nil
    end
end)
-----------
-- ROUPA --
-----------
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
 
RegisterServerEvent("colocar-uniforme:caminhaoantigo")
AddEventHandler("colocar-uniforme:caminhaoantigo",function()
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
 
 
RegisterServerEvent("tirar-uniforme:caminhaoantigo")
AddEventHandler("tirar-uniforme:caminhaoantigo",function()
	local user_id = vRP.getUserId(source)
	vRP.removeCloak(source)
end)
