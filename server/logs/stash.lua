local function handleStash(payload)
    if payload.toType ~= 'stash' and payload.fromType ~= 'stash' then return end
    
    local source = payload.source
    local player = GetPlayerName(source)
    
    local discord = nil
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:match('discord:') then
            discord = id:gsub('discord:', '')
            break
        end
    end

    local isStoring = payload.toType == 'stash'
    local item = payload.fromSlot.name
    local count = payload.count
    local serial = nil    
    
    if item:match('^WEAPON_') and payload.fromSlot.metadata then
        serial = payload.fromSlot.metadata.serial
    end

    local stashId = isStoring and payload.toInventory or payload.fromInventory
    local action = isStoring and 'Stored' or 'Removed'
    
    SendDiscordLog('stash', {
        player = player,
        discord = discord,
        item = item,
        amount = count,
        serial = serial,
        stash = stashId,
        action = action
    })
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports.ox_inventory:registerHook('swapItems', function(payload)
            handleStash(payload)
            return true
        end, {
            print = false
        })
    end
end) 