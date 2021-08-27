-- This is the command that will open the medical record
RegisterCommand('ficha', function(source, args)
    local idJ = source

    -- Here you define wihch job will be alowed to open the medical Record
    -- exemplo: if xPlayer.job.name == 'Medic' then
    MySQL.Async.fetchAll('SELECT COUNT(id) AS consultations FROM medical_record', 
    {},
    function(result) 
        TriggerClientEvent('lg:openRecord', idJ, result[1])
    end)
end)

-- Create Table
CreateThread(function()
    MySQL.Async.execute('CREATE TABLE IF NOT EXISTS medical_record(id int AUTO_INCREMENT, id_user int, name_user varchar(100), sangue varchar(10), reason varchar(200), description varchar(200), PRIMARY KEY(id))', {}, function()
    end)
end)

RegisterNetEvent("lg:registerConsult")
AddEventHandler("lg:registerConsult", function(data)
    MySQL.Async.execute('INSERT INTO medical_record(id_user, name_user, sangue, reason, description) VALUES (@id_user, @name_user, @sangue, @reason, @description)', 
    {
        ['@id_user'] = data.id_user,
        ['@name_user'] = data.name_user,
        ['@sangue'] = data.sangue,
        ['@reason'] = data.reason,
        ['@description'] = data.description
    },
    function() 

    end)
end)

RegisterNetEvent("lg:getAllConsultations")
AddEventHandler("lg:getAllConsultations", function()
    local idJ = source 

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record GROUP BY id_user', 
    {},
    function(result) 
        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getIdConsultations")
AddEventHandler("lg:getIdConsultations", function(value)
    local idJ = source 

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record WHERE id_user = @id_user GROUP BY id_user', 
    {
        ['@id_user'] = value
    },
    function(result) 
        
        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getNameConsultations")
AddEventHandler("lg:getNameConsultations", function(value)
    local idJ = source 

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record WHERE name_user = @name_user GROUP BY id_user', 
    {
        ['@name_user'] = value
    },
    function(result) 
        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getPacient")
AddEventHandler("lg:getPacient", function(data)
    local idJ = source 

    MySQL.Async.fetchAll('SELECT * FROM medical_record WHERE id_user = @id_user', 
    {
        ['@id_user'] = data.id_user
    },
    function(result) 
        TriggerClientEvent("lg:getPacient", idJ, result)
    end)
end)
