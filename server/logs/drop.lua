local function handleDropAndPickup(payload)
    if payload.toType == 'drop' then
        local source = payload.source
        local player = GetPlayerName(source)
        
        local discord = nil
        for _, id in ipairs(GetPlayerIdentifiers(source)) do
            if id:match('discord:') then
                discord = id:gsub('discord:', '')
                break
            end
        end

        local item = payload.fromSlot.name
        local count = payload.count
        local serial = nil    
        if payload.fromSlot.metadata and payload.fromSlot.metadata.serial then
            serial = payload.fromSlot.metadata.serial
        end

        local coords = GetEntityCoords(GetPlayerPed(source))
        local location = string.format('%.2f, %.2f, %.2f', coords.x, coords.y, coords.z)
        
        SendDiscordLog('drop', {
            description = 'Item Dropped',
            player = player,
            discord = discord,
            item = item,
            amount = count,
            serial = serial,
            location = location,
            action = 'Dropped'
        })
    end
    
    if payload.fromType == 'drop' then
        local source = payload.source
        local player = GetPlayerName(source)
        
        local discord = nil
        for _, id in ipairs(GetPlayerIdentifiers(source)) do
            if id:match('discord:') then
                discord = id:gsub('discord:', '')
                break
            end
        end

        local item = payload.fromSlot.name
        local count = payload.count
        local serial = nil    
        if payload.fromSlot.metadata and payload.fromSlot.metadata.serial then
            serial = payload.fromSlot.metadata.serial
        end

        local coords = GetEntityCoords(GetPlayerPed(source))
        local location = string.format('%.2f, %.2f, %.2f', coords.x, coords.y, coords.z)
        
        SendDiscordLog('pickup', {
            description = 'Item Picked Up',
            player = player,
            discord = discord,
            item = item,
            amount = count,
            serial = serial,
            location = location,
            action = 'Picked Up'
        })
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports.ox_inventory:registerHook('swapItems', function(payload)
            handleDropAndPickup(payload)
            return true
        end, {
            print = false
        })
    end
end) 