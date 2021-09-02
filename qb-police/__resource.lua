resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
 'config.lua',
 'client/alerts.lua',
 'client/evidence.lua',
 'client/gui.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 "html/index.html",
 "html/js/script.js",
 "html/js/vue.min.js",
 "html/img/tablet-frame.png",
 "html/img/fingerprint.png",
 "html/main.css",
}

exports {
 "IsWeaponSilent",
 "GetWeaponCategory",
 "AddAlertBlip",
 'GetGarageStatus',
 "GetImpoundStatus",
 'GetVehicleList',
 "GetEscortStatus",
}

server_exports {
 'GetCurrentCops',
}