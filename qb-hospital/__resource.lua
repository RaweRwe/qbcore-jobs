resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
 'config.lua',
 'client/dead.lua',
 'client/wounds.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua'
}

exports {
 'NearGarage',
 'GetDeathStatus',
}