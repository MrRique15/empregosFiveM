RegisterCommand('objects', function(source, args)

    -- coloque a verificação de administrador aqui
    -- example: if user.permission_level == (2) then
    MySQL.Async.fetchAll('SELECT * FROM props_spawn',
    {

    },function(result)
        TriggerClientEvent('lg: openPropMenu', source, result)
    end)
end)

RegisterCommand('propremove', function(source, args)
    -- coloque a verificação de administrador aqui
    -- example: if user.permission_level == (2) then
    TriggerClientEvent('lg: removeClosestProp', source)
end)

RegisterCommand('propremove_all', function(source, args)
    -- coloque a verificação de administrador aqui
    -- example: if user.permission_level == (2) then
    MySQL.Async.execute('TRUNCATE TABLE props_spawn',
    {
    },function(result)
        TriggerClientEvent('lg: removeAllProps', -1)
    end)
end)

CreateThread(function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS props_spawn( id int AUTO_INCREMENT, prop varchar(200), pos_x varchar(10), pos_y varchar(10), pos_z varchar(10), heading varchar(10), status int DEFAULT 1, folder varchar(50) DEFAULT 'none', PRIMARY KEY(id) )", {}, function() end)
    MySQL.Async.execute("ALTER TABLE props_spawn ADD COLUMN IF NOT EXISTS folder varchar(50) DEFAULT 'none' ", {}, function() end)
end)

RegisterNetEvent('lg: insertProp')
AddEventHandler('lg: insertProp', function(data)
    local idJ = source

    local x = string.format("%.2f", tonumber(data.pos_x))
    local y = string.format("%.2f", tonumber(data.pos_y))
    local z = string.format("%.2f", tonumber(data.pos_z))
    local heading = string.format("%.2f", tonumber(data.heading))

    MySQL.Async.insert('INSERT INTO props_spawn (prop, pos_x, pos_y, pos_z, heading, folder) VALUES (@prop, @pos_x, @pos_y, @pos_z, @heading, @folder)',
    {
        ['@prop'] = data.prop,
        ['@pos_x'] = x,
        ['@pos_y'] = y,
        ['@pos_z'] = z,
        ['@heading'] = heading,
        ['@folder'] = data.folder,
    },
    function(result)
        if result then
            data.id = result
            TriggerClientEvent('lg: updateProp', idJ, data)
            TriggerClientEvent('lg: createClientObject', -1, data)
        end        
    end) 
end)

RegisterNetEvent('lg: saveUpdateProp')
AddEventHandler('lg: saveUpdateProp', function(data)
    local idJ = source

    local x = string.format("%.2f", tonumber(data.pos_x))
    local y = string.format("%.2f", tonumber(data.pos_y))
    local z = string.format("%.2f", tonumber(data.pos_z))
    local heading = string.format("%.2f", tonumber(data.heading))

    MySQL.Async.execute('UPDATE props_spawn set prop = @prop, pos_x = @pos_x, pos_y = @pos_y, pos_z = @pos_z, heading = @heading, folder = @folder WHERE id = @id',
    {
        ['@prop'] = data.prop,
        ['@pos_x'] = x,
        ['@pos_y'] = y,
        ['@pos_z'] = z,
        ['@heading'] = heading,
        ['@folder'] = data.folder,
        ['@id'] = data.id
    },
    function(result)
        if result then
            TriggerClientEvent('lg: updateClientProp', -1, data)
        end        
    end) 
end)

RegisterNetEvent('lg: loadProps')
AddEventHandler('lg: loadProps', function()
    local idJ = source

    MySQL.Async.fetchAll('SELECT * FROM props_spawn WHERE status = 1',
    {

    },function(result)
        TriggerClientEvent('lg: loadProps', idJ, result)
    end)
end)

RegisterNetEvent('lg: changeStatus')
AddEventHandler('lg: changeStatus', function(data)
    local idJ = source

    MySQL.Async.execute('UPDATE props_spawn set status = @status WHERE id = @id',
    {
        ['@status'] = data.status,
        ['@id'] = data.id
    },function(result)
        TriggerClientEvent('lg: changeStatus', idJ, data)
        if tonumber(data.status) == 0 then
            TriggerClientEvent('lg: disableClientProp', -1, data)
        else
            TriggerClientEvent('lg: createClientObject', -1, data)
        end
    end)
end)


RegisterNetEvent('lg: deleteProp')
AddEventHandler('lg: deleteProp', function(data)
    local idJ = source

    MySQL.Async.execute('DELETE FROM props_spawn WHERE id = @id',
    {
        ['@id'] = data.id
    },function(result)
        TriggerClientEvent('lg: disableClientProp', -1, data)
    end)
end)

RegisterNetEvent('lg: loadFolders')
AddEventHandler('lg: loadFolders', function(data)
    local idJ = source
    MySQL.Async.fetchAll('SELECT folder FROM props_spawn GROUP BY folder',
    {
    },function(result)
        TriggerClientEvent('lg: loadFolders', idJ, result)
    end)
end)

RegisterNetEvent('lg: openFolder')
AddEventHandler('lg: openFolder', function(data)
    local idJ = source
    MySQL.Async.fetchAll('SELECT * FROM props_spawn WHERE folder = @folder',
    {
        ['@folder'] = data.folder
    },function(result)
        TriggerClientEvent('lg: openFolder', idJ, result)
    end)
end)

RegisterNetEvent('lg: activeAll')
AddEventHandler('lg: activeAll', function(data)
    local idJ = source
    MySQL.Async.fetchAll('UPDATE props_spawn SET status = 1 WHERE folder = @folder',
    {
        ['@folder'] = data.folder
    },function()
        MySQL.Async.fetchAll('SELECT * FROM props_spawn WHERE folder = @folder',
        {
            ['@folder'] = data.folder
        },function(result)
            TriggerClientEvent('lg: loadProps', -1, result)
        end)
    end)
end)

RegisterNetEvent('lg: disableAll')
AddEventHandler('lg: disableAll', function(data)
    local idJ = source
    MySQL.Async.fetchAll('UPDATE props_spawn SET status = 0 WHERE folder = @folder',
    {
        ['@folder'] = data.folder
    },function()
        MySQL.Async.fetchAll('SELECT * FROM props_spawn WHERE folder = @folder',
        {
            ['@folder'] = data.folder
        },function(result)
            TriggerClientEvent('lg: disableAll', -1, result)
        end)
    end)
end)

RegisterNetEvent('lg: deleteAll')
AddEventHandler('lg: deleteAll', function(data)
    local idJ = source
    MySQL.Async.fetchAll('SELECT * FROM props_spawn WHERE folder = @folder',
    {
        ['@folder'] = data.folder
    },function(result)
        MySQL.Async.fetchAll('DELETE FROM props_spawn WHERE folder = @folder',
        {
            ['@folder'] = data.folder
        },function()
            TriggerClientEvent('lg: disableAll', -1, result)    
        end)        
    end)
end)