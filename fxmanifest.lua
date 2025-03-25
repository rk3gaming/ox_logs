fx_version 'cerulean'
game 'gta5'

name 'ox_logs'
author 'Your Server'
description 'Discord logging system for ox_inventory evidence'

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/locale.lua',
    'server/functions.lua',
    'server/logs/*.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes' 