fx_version 'cerulean'

author 'wilodonny'

game 'gta5'

-- ox_trademan version 1.0

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

dependencies {
    'ox_inventory',
}

lua54 'yes'
