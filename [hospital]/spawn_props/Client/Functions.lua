function getOldObject(id)
    if ObjectsSpawnned[id] then
        local old_x = tonumber(ObjectsSpawnned[id].pos_x)*1.0
        local old_y = tonumber(ObjectsSpawnned[id].pos_y)*1.0
        local old_z = tonumber(ObjectsSpawnned[id].pos_z)*1.0
        return GetClosestObjectOfType(old_x, old_y, old_z, 1.5, ObjectsSpawnned[id].prop, false, false)
    end

    return 0
end

function newObject(data)
    if IsModelValid(data.prop) then
        RequestModel(GetHashKey(data.prop))
        while not HasModelLoaded(GetHashKey(data.prop)) do
            Wait(1)
        end

        local x = tonumber(string.format("%.2f", tonumber(data.pos_x)))*1.0
        local y = tonumber(string.format("%.2f", tonumber(data.pos_y)))*1.0
        local z = tonumber(string.format("%.2f", tonumber(data.pos_z)))*1.0
        local heading = tonumber(string.format("%.2f", tonumber(data.heading)))*1.0

        ObjectsSpawnned[data.id] = data
        ObjectsSpawnned[data.id].object = CreateObject(GetHashKey(data.prop), x, y, z, false, false, false)

        FreezeEntityPosition(ObjectsSpawnned[data.id].object, true)
        SetEntityCoords(ObjectsSpawnned[data.id].object, x, y, z)
        SetEntityHeading(ObjectsSpawnned[data.id].object, heading)
    else
        print("Wrong Name Prop Object: " .. data.prop)
    end
end

function removeObject(id)
    if(not ObjectsSpawnned[id] or not ObjectsSpawnned[id].object) then
        return
    end

    if(IsEntityAnObject(ObjectsSpawnned[id].object)) then
        DeleteObject(ObjectsSpawnned[id].object)
    else
        ObjectsSpawnned[id].object = getOldObject(id)
        
        if(IsEntityAnObject(ObjectsSpawnned[id].object)) then
            DeleteObject(ObjectsSpawnned[id].object)
        end
    end
end