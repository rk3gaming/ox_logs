local types = {}

function addTypeHook(name, from, to, callback)
    types[name] = {
        from = from,
        to = to,
        callback = callback
    }
end

function SendDiscordLog(webhook, data)
    if not Config.Webhooks[webhook] or Config.Webhooks[webhook] == '' then return end
    
    local fields = {}

    if data.toPlayer then
        fields = {
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.player_name'), data.player),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.discord'), data.discord and string.format('<@%s>', data.discord) or 'Not Linked'),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.given_to'), data.toPlayer),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.receiver_discord'), data.toDiscord and string.format('<@%s>', data.toDiscord) or 'Not Linked'),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.item'), data.item),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.amount'), data.amount),
                inline = false
            }
        }

        if data.serial then
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.serial'), data.serial),
                inline = false
            })
        end
    elseif data.stash then
        fields = {
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.player_name'), data.player),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.discord'), data.discord and string.format('<@%s>', data.discord) or 'Not Linked'),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.item'), data.item),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.amount'), data.amount),
                inline = false
            }
        }

        if data.serial then
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.serial'), data.serial),
                inline = false
            })
        end

        table.insert(fields, {
            name = '⠀',
            value = string.format('%s %s', GetLocale('logs.fields.stash'), data.stash),
            inline = false
        })
        table.insert(fields, {
            name = '⠀',
            value = string.format('%s %s', GetLocale('logs.fields.action'), data.action),
            inline = false
        })
    elseif data.location then
        fields = {
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.player_name'), data.player),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.discord'), data.discord and string.format('<@%s>', data.discord) or 'Not Linked'),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.item'), data.item),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.amount'), data.amount),
                inline = false
            }
        }

        if data.serial then
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.serial'), data.serial),
                inline = false
            })
        end

        table.insert(fields, {
            name = '⠀',
            value = string.format('%s %s', GetLocale('logs.fields.location'), data.location),
            inline = false
        })
    else
        fields = {
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.player_name'), data.player),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.discord'), data.discord and string.format('<@%s>', data.discord) or 'Not Linked'),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.item'), data.item),
                inline = false
            },
            {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.amount'), data.amount),
                inline = false
            }
        }

        if data.serial then
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.serial'), data.serial),
                inline = false
            })
        end

        if data.locker then
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.evidence_locker'), '#'..data.locker),
                inline = false
            })
            table.insert(fields, {
                name = '⠀',
                value = string.format('%s %s', GetLocale('logs.fields.action'), data.action),
                inline = false
            })
        end
    end
    
    local title, color
    if data.toPlayer then
        title = GetLocale('logs.titles.item_transfer')
        color = 65280 -- Green
    elseif data.location and data.action == GetLocale('logs.actions.dropped') then
        title = GetLocale('logs.titles.item_dropped')
        color = 16776960 -- Yellow
    elseif data.location and data.action == GetLocale('logs.actions.picked_up') then
        title = GetLocale('logs.titles.item_picked')
        color = 5793266 
    elseif data.stash then
        title = data.action == GetLocale('logs.actions.stored') and GetLocale('logs.titles.item_stored') or GetLocale('logs.titles.item_removed')
        color = data.action == GetLocale('logs.actions.stored') and 7506394 or 15418782 -- Purple for storing, Orange for removing
    else
        title = GetLocale('logs.titles.evidence_movement')
        color = (data.action == GetLocale('logs.actions.placed') or data.action == GetLocale('logs.actions.given')) and 65280 or 16711680
    end

    PerformHttpRequest(Config.Webhooks[webhook], function(err, text, headers) end, 'POST', json.encode({
        username = webhook == 'evidence' and GetLocale('logs.webhooks.evidence_logs') 
            or webhook == 'pickup' and GetLocale('logs.webhooks.pickup_logs') 
            or webhook == 'drop' and GetLocale('logs.webhooks.drop_logs') 
            or webhook == 'stash' and GetLocale('logs.webhooks.stash_logs') 
            or GetLocale('logs.webhooks.transfer_logs'),
        embeds = {{
            title = title,
            fields = fields,
            color = color,
            footer = {
                text = os.date('%Y-%m-%d %H:%M:%S')
            },
        }},
    }), { ['Content-Type'] = 'application/json' })
end 