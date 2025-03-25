local function handleEvidence(payload)
    local source = payload.source
    local player = GetPlayerName(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local isRemoving = payload.fromType == 'policeevidence'
    local item, metadata
    
    if isRemoving then
        item = payload.fromSlot.name
        metadata = payload.fromSlot.metadata
    else
        if type(payload.fromSlot) == 'table' and payload.fromSlot.name then
            item = payload.fromSlot.name
            metadata = payload.fromSlot.metadata
        elseif type(payload.toSlot) == 'table' and payload.toSlot.name then
            item = payload.toSlot.name
            metadata = payload.toSlot.metadata
        else
            item = payload.fromSlot
        end
    end
    
    local count = payload.count
    local evidenceId = isRemoving and 
        tostring(payload.fromInventory):gsub('evidence%-', '') or 
        tostring(payload.toInventory):gsub('evidence%-', '')

    local discord = nil
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:match('discord:') then
            discord = id:gsub('discord:', '')
            break
        end
    end

    local serial = nil
    if item:match('^WEAPON_') and metadata and metadata.serial then
        serial = metadata.serial
    end
    
    SendDiscordLog('evidence', {
        description = string.format('Evidence locker #%s activity', evidenceId),
        player = player,
        discord = discord,
        item = item,
        amount = count,
        locker = evidenceId,
        action = isRemoving and 'Removed' or 'Placed',
        serial = serial
    })
end

addTypeHook('evidence_store', 'player', 'policeevidence', handleEvidence)
addTypeHook('evidence_remove', 'policeevidence', 'player', handleEvidence)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:registerHook('swapItems', function(payload)
        if payload.fromType == 'policeevidence' or payload.toType == 'policeevidence' then
            handleEvidence(payload)
        end
        return true
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:removeHooks()
end) 