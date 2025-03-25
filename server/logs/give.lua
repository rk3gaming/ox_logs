local function handleGive(payload)
    if payload.action ~= 'give' then return end

    local source = payload.source
    local fromPlayer = GetPlayerName(source)
    local toPlayer = GetPlayerName(payload.toInventory)
    
    local fromDiscord = nil
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:match('discord:') then
            fromDiscord = id:gsub('discord:', '')
            break
        end
    end

    local toDiscord = nil
    for _, id in ipairs(GetPlayerIdentifiers(payload.toInventory)) do
        if id:match('discord:') then
            toDiscord = id:gsub('discord:', '')
            break
        end
    end

    local item = payload.fromSlot.name
    local count = payload.count
    local serial = nil
    
    if item:match('^WEAPON_') and payload.fromSlot.metadata and payload.fromSlot.metadata.serial then
        serial = payload.fromSlot.metadata.serial
    end
    
    SendDiscordLog('give', {
        description = 'Item Transfer Between Players',
        player = fromPlayer,
        discord = fromDiscord,
        toPlayer = toPlayer,
        toDiscord = toDiscord,
        item = item,
        amount = count,
        serial = serial,
        action = 'Given'
    })
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if GetResourceState('ox_inventory') ~= 'started' then return end
    
    exports.ox_inventory:registerHook('swapItems', function(payload)
        if payload.action == 'give' then
            handleGive(payload)
        end
        return true
    end)
end) 